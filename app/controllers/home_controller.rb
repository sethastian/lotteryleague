class HomeController < InheritedResources::Base
  helper_method :redirect_to

  def calculate_trade
  end

  def livePlayerPicture
    @draft = Draft.first
    @draft.update(livePlayer: params[:liveplayer].to_i)
    @draft.save
    @player = Player.where(number: params[:liveplayer].to_i).first
  end

  def tradedbands
    @band1 = Band.where(number: params[:band1].to_i).first
    @band2 = Band.where(number: params[:band2].to_i).first
    if (!@band1.player1.blank?)
      @b1Player1 = Player.where(number: @band1.player1.to_i).first
    end
    if (!@band1.player2.blank?)
      @b1Player2 = Player.where(number: @band1.player2.to_i).first
    end
    if (!@band1.player3.blank?)
      @b1Player3 = Player.where(number: @band1.player3.to_i).first
    end
    if (!@band1.player4.blank?)
      @b1Player4 = Player.where(number: @band1.player4.to_i).first
    end
    if (!@band2.player1.blank?)
      @b2Player1 = Player.where(number: @band2.player1.to_i).first
    end
    if (!@band2.player2.blank?)
      @b2Player2 = Player.where(number: @band2.player2.to_i).first
    end
    if (!@band2.player3.blank?)
      @b2Player3 = Player.where(number: @band2.player3.to_i).first
    end
    if (!@band2.player4.blank?)
      @b2Player4 = Player.where(number: @band2.player4.to_i).first
    end
  end

  def mjView
    @draftPlayer = Player.where(number: Draft.first.livePlayer.to_i).first
    @draftName = @draftPlayer.name
    @draftBand = @draftPlayer.currentBandName
    @draftInstrument = @draftPlayer.instrument

    @band2008 = @draftPlayer.band2008
    @band2010 = @draftPlayer.band2010
    @band2013 = @draftPlayer.band2013
    @description = @draftPlayer.description
    gon.watch.draftName = @draftName
    gon.watch.draftBand = @draftBand
    gon.watch.band2008 = @band2008
    gon.watch.band2010 = @band2010
    gon.watch.band2013 = @band2013
    gon.watch.description = @description
    gon.watch.draftInstrument = @draftInstrument
    gon.watch.liveplayer = @draftPlayer
  end

  def livetrade
    @newPlayer = Player.where(number: params[:newPlayer].to_i).first.name
    @previousBand = params[:previousBand]
    @currentBand = params[:currentBand]
    @currentPlayer = Player.where(number: params[:player].to_i).first.name
    gon.watch.newplayer = @newPlayer
    gon.watch.previousband = @previousBand
    gon.watch.currentplayer = @currentPlayer
  end


  def livePlayer
    @livePlayer = Draft.first.livePlayer
  end


  def livedraft
  end


  def updatedBand
    bandNum = Draft.first.liveBand.to_i
    if (bandNum == 1)
      @band = Band.where(number: Draft.first.numberOfBands).first
    else
      @band = Band.where(number: (bandNum - 1)).first
    end
  end


  def bands
    @liveband = Draft.first.liveBand.to_i
    gon.watch.liveband = @liveband
  end


  def comptest
    @draft = Draft.all.first
    @band = Band.where(number: @draft.liveBand.to_i).first
  end

  def old_band_new_band
    @player = Player.where(number: params[:player_number]).first
    @previous_band = Band.where(number: params[:previous_band].to_i).first
    @current_band = Band.where(number: params[:current_band].to_i).first

    @current_band.fill_last_slot(params[:previous_band_player])
    @current_band.save

    @previous_band.replace_last_player(params[:player_number])
    @previous_band.save

    draft = Draft.first
    if (params[:current_band].to_i == draft.numberOfBands) #at the end of the round, cycle to new round
      newround = (draft.round.to_i + 1).to_s
      draft.update(liveBand: "1", round: newround)
    else
      draft.update(liveBand: ((params[:current_band].to_i) + 1).to_s)
    end

    draft.save
  end


  def add_player_to_band
    @draft = Draft.all.first
    @band = Band.where(number: params[:band].to_i).first

    if %w[1 2 3 4].include?(params[:round])
      @band.update("player#{params[:round]}".to_sym => params[:player])
      @band.players << Player.where(number: params[:player].to_i).first
    end

    if (params[:band].to_i == @draft.numberOfBands) #at the end of the round, cycle to new round
      @newround = (params[:round].to_i + 1).to_s
      @draft.update(liveBand: "1", round: @newround)
    else
      @draft.update(liveBand: ((params[:band].to_i) + 1).to_s)
    end

    @draft.save
    redirect_to liveplayer_path
  end

  def compatible
    if player_compatible_with_band?(params[:player_number], params[:band_number])
      redirect_to compatible_player_path(player: params[:player_number], :band => params[:band_number], :round => params[:round]) and return
    else
      redirect_to incompatible_player_path(:player => params[:player_number], :band => params[:band_number], :round => params[:round]) and return
    end
  end

  def player_compatible_with_band?(player_number, band_number, trade = false)
    compatible = true

    compare_player = Player.find_by_number(player_number)
    compare_player_related_player_numbers = compare_player.related_players.map(&:number)

    band = Band.find_by_number(band_number)
    band_player_numbers = [band.player1, band.player2, band.player3, band.player4].reject(&:blank?)

    # remove last player if trade test
    if trade
      band_player_numbers = band_player_numbers.reverse.drop(1).reverse
    end

    band_player_numbers.each do |band_player_number|
      band_player = Player.find_by_number(band_player_number.to_i)
      if band_player.related_players.to_a.map(&:id).include?(compare_player.id)
        compatible = false
      end
    end

    if !((band_player_numbers & compare_player_related_player_numbers).empty?)
      compatible = false
    end

    compatible
  end

  def get_previous_band(current_band_number)
    if (current_band_number == 1)
      band = Band.where(number: Draft.first.numberOfBands).first
    else
      band = Band.where(number: (current_band_number - 1)).first
    end

    band
  end

  def commit_trade_countdown
    @player = Player.where(number: params[:player_number]).first
    @previous_band = params[:check_compatibility] ? Band.where(number: params[:previous_band].to_i).first : get_previous_band(params[:previous_band].to_i)
    @current_band = Band.where(number: params[:current_band].to_i).first

    @compatible = "trade"

    if params[:check_compatibility]
      @compatible = "incompatible"
      trade = true
      if player_compatible_with_band?(params[:player_number].to_i, @previous_band.number.to_i, trade)
        previous_band_player_numbers = [@previous_band.player4, @previous_band.player3, @previous_band.player2, @previous_band.player1].reject(&:blank?)
        if player_compatible_with_band?(previous_band_player_numbers[0], params[:current_band])
          @compatible = "compatible"
          @previous_band_player = previous_band_player_numbers[0]
        end
      end
    end

  end

  def commit_trade

    player = params[:player].to_i
    band = params[:band].to_i
    compBand = params[:compBand].to_i
    bandRound = params[:bandRound].to_i
    compBandRound = params[:compBandRound].to_i

    @currentBand = Band.where(number: band).first
    @compBand = Band.where(number: compBand).first

    compBandPrevRound = 0
    prevBandPrevRound = 0


    if (compBand == 1)
      @prevBand = Band.where(number: Draft.first.numberOfBands)
    else
      @prevBand = Band.where(number: (compBand - 1)).first
    end

    @player = Player.where(number: player).first

    @currentBandPlayer1 = @currentBand.player1
    @currentBandPlayer2 = @currentBand.player2
    @currentBandPlayer3 = @currentBand.player3
    @currentBandPlayer4 = @currentBand.player4

    @compBandPlayer1 = @compBand.player1
    @compBandPlayer2 = @compBand.player2
    @compBandPlayer3 = @compBand.player3
    @compBandPlayer4 = @compBand.player4


    if (bandRound == 4)
      if (compBandRound < bandRound)
        @comp1 = 0
        @comp2 = 0


        #Check if player is compatible with previous band
        @player.related_players.each do |p|
          if (p.number == @compBandPlayer1.to_i || p.number == @compBandPlayer2.to_i)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        #Check if previous player is compatible with current band

        Player.where(number: @compBandPlayer3.to_i).first.related_players.each do |p|
          if (p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i || p.number == @currentBandPlayer3.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer3.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer3.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer3.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer3.to_i)
            @comp2 = 1
          end
        end


        if (@comp1 == 1 || @comp2 == 1)
          commit_trade(player, band, @prevBand, bandRound, compBandRound)
        else
          @currentBand.update(player4: @compBandPlayer3)
          @currentBand.save
          @compBand.update(player3: player)

          #Update Draft Liveband and Round
          @draft = Draft.first
          if (@draft.liveBand.to_i == @draft.numberOfBands) #at the end of the round, cycle to new round
            @newround = (@draft.round + 1).to_s
            @draft.update(liveBand: "1", round: @newround)
          else
            @draft.update(liveBand: ((@draft.liveBand.to_i) + 1).to_s)
          end

          redirect_to livedraft_path and return
        end
      else
        @comp1 = 0
        @comp2 = 0

        #Check if player is compatible with previous band
        @player.related_players.each do |p|
          if (p.number == @compBandPlayer1.to_i || p.number == @compBandPlayer2.to_i || p.number == @compBandPlayer3.to_i)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer3.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        #Check if player 4 from previous band is compatible with current band

        Player.where(number: @compBandPlayer4.to_i).first.related_players.each do |p|
          if (p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i || p.number == @currentBandPlayer3.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer4.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer4.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer3.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer4.to_i)
            @comp2 = 1
          end
        end

        if (@comp1 == 1 || @comp2 == 1)
          if (compBand == 1)
            commit_trade(player, band, @prevBand, bandRound, (compBandRound - 1))
          else
            commit_trade(player, band, @prevBand, bandRound, compBandRound)
          end
        else
          @currentBand.update(player4: @compBandPlayer4)
          @currentBand.save
          @compBand.update(player4: player)
          @compBand.save

          #Update Draft Liveband and Round
          @draft = Draft.first
          if (@draft.liveBand.to_i == @draft.numberOfBands) #at the end of the round, cycle to new round
            @newround = (@draft.round + 1).to_s
            @draft.update(liveBand: "1", round: @newround)
          else
            @draft.update(liveBand: ((@draft.liveBand.to_i) + 1).to_s)
          end

          #FINAL ACTION
          redirect_to livedraft_path and return
        end
      end
    elsif (bandRound == 3)

      if (compBandRound < bandRound)
        @comp1 = 0
        @comp2 = 0


        #Check if Player is compatible with previous band
        @player.related_players.each do |p|
          if (p.number == @compBandPlayer1.to_i)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp2 = 1
          end
        end

        #Check if previous band player 2 is compatible with new band in round 3
        Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer2.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer2.to_i)
            @comp2 = 1
          end
        end

        if (@comp1 == 1 || @comp2 == 2)
          commit_trade(player, band, @prevBand, bandRound, compBandRound)
        else
          @currentBand.update(player3: @compBandPlayer3)
          @currentBand.save
          @compBand.update(player2: player)

          #Update Draft Liveband and Round
          @draft = Draft.first
          if (@draft.liveBand.to_i == @draft.numberOfBands) #at the end of the round, cycle to new round
            @newround = (@draft.round + 1).to_s
            @draft.update(liveBand: "1", round: @newround)
          else
            @draft.update(liveBand: ((@draft.liveBand.to_i) + 1).to_s)
          end

          redirect_to livedraft_path and return
        end
      else
        @comp1 = 0
        @comp2 = 0

        #Check if player is compatible with previous band
        @player.related_players.each do |p|
          if (p.number == @compBandPlayer1.to_i || p.number == @compBandPlayer2.to_i)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp1 = 1
          end
        end

        #Check if player 3 in previous band is compatible with new band
        Player.where(number: @compBandPlayer3.to_i).first.related_players.each do |p|
          if (p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer3.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer3.to_i)
            @comp2 = 1
          end
        end

        #trade_path(:player => @player, :band => @band, :compBand => @compBand, :bandRound => @round, :compBandRound => @compBandRound)


        if (@comp1 == 1 || @comp2 == 1)
          if (compBand == 1)
            commit_trade(player, band, @prevBand, bandRound, (compBandRound - 1))
          else
            commit_trade(player, band, @prevBand, bandRound, compBandRound)
          end
        else
          @currentBand.update(player3: @compBandPlayer3)
          @currentBand.save
          @compBand.update(player3: player)
          @compBand.save

          #Update Draft Liveband and Round
          @draft = Draft.first
          if (@draft.liveBand.to_i == @draft.numberOfBands) #at the end of the round, cycle to new round
            @newround = (@draft.round + 1).to_s
            @draft.update(liveBand: "1", round: @newround)
          else
            @draft.update(liveBand: ((@draft.liveBand.to_i) + 1).to_s)
          end

          redirect_to livedraft_path and return
        end
      end
    elsif (bandRound == 2)
      if (compBandRound < bandRound)
        redirect_to livedraft_path and return
      else
        @comp1 = 0
        @comp2 = 0

        #Check player one against previous band
        @player.related_players.each do |p|
          if (p.number == @compBandPlayer1.to_i)
            @comp1 = 1
          end
        end

        Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == player)
            @comp2 = 1
          end
        end

        #Check switched player with new band

        Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
          if (p.number == @currentBandPlayer1.to_i)
            @comp2 = 1
          end
        end

        Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
          if (p.number == @compBandPlayer2.to_i)
            @comp2 = 1
          end
        end

        if (@comp1 == 1 || @comp2 == 1)
          if (compBand == 1)
            commit_trade(player, band, @prevBand, bandRound, (compBandRound - 1))
          else
            commit_trade(player, band, @prevBand, bandRound, compBandRound)
          end
        else
          @currentBand.update(player2: @compBandPlayer2)
          @currentBand.save
          @compBand.update(player2: player)
          @compBand.save

          #Update Draft Liveband and Round
          @draft = Draft.first
          if (@draft.liveBand.to_i == @draft.numberOfBands) #at the end of the round, cycle to new round
            @newround = (@draft.round + 1).to_s
            @draft.update(liveBand: "1", round: @newround)
          else
            @draft.update(liveBand: ((@draft.liveBand.to_i) + 1).to_s)
          end

          redirect_to livedraft_path and return
        end
      end
    else
      redirect_to livedraft_path and return
    end

  end


  def compatible_old
    @player1 = Player.find_by_number(params[:player1])
    @player2 = Player.find_by_number(params[:player2])
    @player3 = Player.find_by_number(params[:player3])
    @player4 = Player.find_by_number(params[:player4])

    if (!params[:player4].blank?)
      @player4.related_players.each do |p|
        if ((p.number.to_s == params[:player3].to_s) || (p.number == params[:player2].to_s) || (p.number == params[:player1].to_s))
          puts "1"
          redirect_to incompatible_player_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end

      end
      @player3.related_players.each do |p|
        if (p.number.to_s == params[:player4].to_s)

          redirect_to incompatible_player_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player2.related_players.each do |p|
        if (p.number.to_s == params[:player4].to_s)

          redirect_to incompatible_player_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player1.related_players.each do |p|
        if (p.number.to_s == params[:player4].to_s)

          redirect_to incompatible_player_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end
      end
      redirect_to compatible_player_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
    elsif (!params[:player3].blank?)
      @player3.related_players.each do |p|

        if ((p.number.to_s == params[:player2].to_s) || (p.number.to_s == params[:player1].to_s))
          puts p.number.to_s
          redirect_to incompatible_player_path(player: params[:player3], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player2.related_players.each do |p|
        if (p.number.to_s == params[:player3].to_s)

          redirect_to incompatible_player_path(player: params[:player3], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player1.related_players.each do |p|
        if (p.number.to_s == params[:player3].to_s)

          redirect_to incompatible_player_path(player: params[:player3], :band => params[:band], :round => params[:round]) and return
        end
      end
      redirect_to compatible_player_path(:player => params[:player3], :band => params[:band], :round => params[:round]) and return
    elsif (!params[:player2].blank?)
      @player2.related_players.each do |p|
        if ((p.number.to_s == params[:player1].to_s))
          redirect_to incompatible_player_path(player: params[:player2], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player1.related_players.each do |p|
        if (p.number.to_s == params[:player2].to_s)
          redirect_to incompatible_player_path(player: params[:player2], :band => params[:band], :round => params[:round]) and return
        end
      end
      redirect_to compatible_player_path(:player => params[:player2], :band => params[:band], :round => params[:round]) and return
    else
      redirect_to compatible_player_path(:player => params[:player1], :band => params[:band], :round => params[:round]) and return
    end

  end


  def compatiblePlayer
    @draft = Draft.all.first
    @band = Band.where(number: @draft.liveBand.to_i).first
  end

  def incompatiblePlayer

    @draft = Draft.all.first
    @band = params[:band].to_i
    @player = params[:player].to_i
    @round = params[:round].to_i
    if (@band == 1)
      @compBand = Draft.first.numberOfBands
      @compBandRound = @round - 1
    else
      @compBand = @band - 1
      @compBandRound = @round
    end
  end

  def compatiblesingleplayer
  end

  def incompatiblesingleplayer
  end


  def compatiblesingle
    @player1 = Player.find_by_number(params[:player1])
    @player2 = Player.find_by_number(params[:player2])
    @player3 = Player.find_by_number(params[:player3])
    @player4 = Player.find_by_number(params[:player4])

    if (!params[:player4].blank?)
      @player4.related_players.each do |p|
        if ((p.number.to_s == params[:player3].to_s) || (p.number == params[:player2].to_s) || (p.number == params[:player1].to_s))
          puts "1"
          redirect_to incompatiblesingleplayer_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end

      end
      @player3.related_players.each do |p|
        if (p.number.to_s == params[:player4].to_s)

          redirect_to incompatiblesingleplayer_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player2.related_players.each do |p|
        if (p.number.to_s == params[:player4].to_s)

          redirect_to incompatiblesingleplayer_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player1.related_players.each do |p|
        if (p.number.to_s == params[:player4].to_s)

          redirect_to incompatiblesingleplayer_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
        end
      end
      redirect_to compatiblesingleplayer_path(player: params[:player4], :band => params[:band], :round => params[:round]) and return
    elsif (!params[:player3].blank?)
      @player3.related_players.each do |p|

        if ((p.number.to_s == params[:player2].to_s) || (p.number.to_s == params[:player1].to_s))
          puts p.number.to_s
          redirect_to incompatiblesingleplayer_path(player: params[:player3], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player2.related_players.each do |p|
        if (p.number.to_s == params[:player3].to_s)

          redirect_to incompatiblesingleplayer_path(player: params[:player3], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player1.related_players.each do |p|
        if (p.number.to_s == params[:player3].to_s)

          redirect_to incompatiblesingle_player_path(player: params[:player3], :band => params[:band], :round => params[:round]) and return
        end
      end
      redirect_to compatiblesingleplayer_path(:player => params[:player3], :band => params[:band], :round => params[:round]) and return
    elsif (!params[:player2].blank?)
      @player2.related_players.each do |p|
        if ((p.number.to_s == params[:player1].to_s))
          redirect_to incompatiblesingleplayer_path(player: params[:player2], :band => params[:band], :round => params[:round]) and return
        end
      end
      @player1.related_players.each do |p|
        if (p.number.to_s == params[:player2].to_s)
          redirect_to incompatiblesingleplayer_path(player: params[:player2], :band => params[:band], :round => params[:round]) and return
        end
      end
      redirect_to compatiblesingleplayer_path(:player => params[:player2], :band => params[:band], :round => params[:round]) and return
    else
      redirect_to compatiblesingleplayer_path(:player => params[:player1], :band => params[:band], :round => params[:round]) and return
    end

  end

  def z_image_test
  end


end