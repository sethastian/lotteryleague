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


  def mjView
  	@draftPlayer = Draft.first.livePlayer
  	gon.watch.liveplayer = @draftPlayer
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

  def add_player_to_band
  	@draft = Draft.all.first
  	@band = Band.where(number: params[:band].to_i).first
  	
  	if (params[:round] == "1")
  		@band.update(player1: params[:player])
  		@band.players << Player.where(number: params[:player].to_i).first
  	end
  	
  	if (params[:round] == "2")
  		@band.update(player2: params[:player])
  		@band.players << Player.where(number: params[:player].to_i).first
  	end

  	if (params[:round] == "3")
  		@band.update(player3: params[:player])
  		@band.players << Player.where(number: params[:player].to_i).first
  	end

  	if (params[:round] == "4")
  		@band.update(player4: params[:player])
  		@band.players << Player.where(number: params[:player].to_i).first
  	end

  	if (params[:band].to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
  		@newround = (params[:round].to_i + 1).to_s
  		@draft.update(liveBand: "1", round: @newround)	
  	else
  		@draft.update(liveBand: ((params[:band].to_i)+1).to_s)
  	end

  	@draft.save
  	redirect_to liveplayer_path
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
  		@prevBand = Band.where(number: (compBand-1)).first
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
  		if(compBandRound < bandRound)
	  		@comp1 = 0
	  		@comp2 = 0
	  		

	  		#Check if player is compatible with previous band
	  		@player.related_players.each do |p|
	  			if(p.number == @compBandPlayer1.to_i || p.number == @compBandPlayer2.to_i)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		#Check if previous player is compatible with current band

	  		Player.where(number: @compBandPlayer3.to_i).first.related_players.each do |p|
	  			if(p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i || p.number == @currentBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer3.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end


	  		if(@comp1 == 1 || @comp2 == 1)
  				commit_trade(player, band, @prevBand, bandRound, compBandRound)
  			else
  				@currentBand.update(player4: @compBandPlayer3)
  				@currentBand.save
  				@compBand.update(player3: player)

  				#Update Draft Liveband and Round
  				@draft = Draft.first
  				if (@draft.liveBand.to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
			  		@newround = (@draft.round + 1).to_s
			  		@draft.update(liveBand: "1", round: @newround)	
			  	else
			  		@draft.update(liveBand: ((@draft.liveBand.to_i)+1).to_s)
			  	end

  				redirect_to livedraft_path and return
  			end
  		else
  			@comp1 = 0
	  		@comp2 = 0

			#Check if player is compatible with previous band
	  		@player.related_players.each do |p|
	  			if(p.number == @compBandPlayer1.to_i || p.number == @compBandPlayer2.to_i || p.number == @compBandPlayer3.to_i)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer3.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		#Check if player 4 from previous band is compatible with current band

	  		Player.where(number: @compBandPlayer4.to_i).first.related_players.each do |p|
	  			if(p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i || p.number == @currentBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer4.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer4.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer3.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer4.to_i)
	  				@comp2 = 1
	  			end
	  		end
	  		
	  		if(@comp1 == 1 || @comp2 == 1)
	  			if (compBand == 1)
  					commit_trade(player, band, @prevBand, bandRound, (compBandRound-1) )
  				else
  					commit_trade(player, band, @prevBand, bandRound, compBandRound )
  				end
  			else
  				@currentBand.update(player4: @compBandPlayer4)
  				@currentBand.save
  				@compBand.update(player4: player)
  				@compBand.save

  				#Update Draft Liveband and Round
  				@draft = Draft.first
  				if (@draft.liveBand.to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
			  		@newround = (@draft.round + 1).to_s
			  		@draft.update(liveBand: "1", round: @newround)	
			  	else
			  		@draft.update(liveBand: ((@draft.liveBand.to_i)+1).to_s)
			  	end

			  	#FINAL ACTION
  				redirect_to livedraft_path and return
  			end
  		end
  	elsif (bandRound == 3)

  		if(compBandRound < bandRound)
	  		@comp1 = 0
	  		@comp2 = 0


	  		#Check if Player is compatible with previous band
	  		@player.related_players.each do |p|
	  			if(p.number == @compBandPlayer1.to_i)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp2 = 1
	  			end
	  		end

	  		#Check if previous band player 2 is compatible with new band in round 3
	  		Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer2.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer2.to_i)
	  				@comp2 = 1
	  			end
	  		end
	  		
	  		if(@comp1 == 1 || @comp2 == 2)
  				commit_trade(player, band, @prevBand, bandRound, compBandRound)
  			else
  				@currentBand.update(player3: @compBandPlayer3)
  				@currentBand.save
  				@compBand.update(player2: player)

  				#Update Draft Liveband and Round
  				@draft = Draft.first
  				if (@draft.liveBand.to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
			  		@newround = (@draft.round + 1).to_s
			  		@draft.update(liveBand: "1", round: @newround)	
			  	else
			  		@draft.update(liveBand: ((@draft.liveBand.to_i)+1).to_s)
			  	end

  				redirect_to livedraft_path and return
  			end
  		else
  			@comp1 = 0
	  		@comp2 = 0

	  		#Check if player is compatible with previous band
	  		@player.related_players.each do |p|
	  			if(p.number == @compBandPlayer1.to_i || p.number == @compBandPlayer2.to_i)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp1 = 1
	  			end
	  		end

	  		#Check if player 3 in previous band is compatible with new band
	  		Player.where(number: @compBandPlayer3.to_i).first.related_players.each do |p|
	  			if(p.number == @currentBandPlayer1.to_i || p.number == @currentBandPlayer2.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer3.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		#trade_path(:player => @player, :band => @band, :compBand => @compBand, :bandRound => @round, :compBandRound => @compBandRound)

	  		
	  		if(@comp1 == 1 || @comp2 == 1)
	  			if (compBand == 1)
  					commit_trade(player, band, @prevBand, bandRound, (compBandRound-1) )
  				else
  					commit_trade(player, band, @prevBand, bandRound, compBandRound )
  				end
  			else
  				@currentBand.update(player3: @compBandPlayer3)
  				@currentBand.save
  				@compBand.update(player3: player)
  				@compBand.save

  				#Update Draft Liveband and Round
  				@draft = Draft.first
  				if (@draft.liveBand.to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
			  		@newround = (@draft.round + 1).to_s
			  		@draft.update(liveBand: "1", round: @newround)	
			  	else
			  		@draft.update(liveBand: ((@draft.liveBand.to_i)+1).to_s)
			  	end

  				redirect_to livedraft_path and return
  			end
  		end
  	elsif (bandRound == 2)
  		if(compBandRound < bandRound)
	  		redirect_to livedraft_path and return
  		else
  			@comp1 = 0
	  		@comp2 = 0

	  		#Check player one against previous band
	  		@player.related_players.each do |p|
	  			if(p.number == @compBandPlayer1.to_i)
	  				@comp1 = 1
	  			end
	  		end

	  		Player.where(number: @compBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == player)
	  				@comp2 = 1
	  			end
	  		end

	  		#Check switched player with new band

	  		Player.where(number: @compBandPlayer2.to_i).first.related_players.each do |p|
	  			if(p.number == @currentBandPlayer1.to_i)
	  				@comp2 = 1
	  			end
	  		end

	  		Player.where(number: @currentBandPlayer1.to_i).first.related_players.each do |p|
	  			if(p.number == @compBandPlayer2.to_i)
	  				@comp2 = 1
	  			end
	  		end
	  		
	  		if(@comp1 == 1 || @comp2 == 1)
	  			if (compBand == 1)
  					commit_trade(player, band, @prevBand, bandRound, (compBandRound-1) )
  				else
  					commit_trade(player, band, @prevBand, bandRound, compBandRound )
  				end
  			else
  				@currentBand.update(player2: @compBandPlayer2)
  				@currentBand.save
  				@compBand.update(player2: player)
  				@compBand.save

  				#Update Draft Liveband and Round
  				@draft = Draft.first
  				if (@draft.liveBand.to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
			  		@newround = (@draft.round + 1).to_s
			  		@draft.update(liveBand: "1", round: @newround)	
			  	else
			  		@draft.update(liveBand: ((@draft.liveBand.to_i)+1).to_s)
			  	end

  				redirect_to livedraft_path and return
  			end
  		end
  	else
  		redirect_to livedraft_path and return
  	end


  end

  def compatible
  	@player1 = Player.find_by_number(params[:player1])
  	@player2 = Player.find_by_number(params[:player2])
  	@player3 = Player.find_by_number(params[:player3])
  	@player4 = Player.find_by_number(params[:player4])

  	if (!params[:player4].blank?)
		@player4.related_players.each do |p|
			if ( (p.number.to_s == params[:player3].to_s) || (p.number == params[:player2].to_s) || (p.number == params[:player1].to_s) )
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
	elsif(!params[:player3].blank?)
		@player3.related_players.each do |p|
			if ( (p.number.to_s == params[:player2].to_s) || (p.number.to_s == params[:player1]).to_s )
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
	elsif(!params[:player2].blank?)
		@player2.related_players.each do |p|
			if ( (p.number.to_s == params[:player1].to_s) )
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

end