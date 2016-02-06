module ApplicationHelper

	#@currentBand = Draft.first.liveBand


	def update_draft_round
		@draft = Draft.first
		if (@draft.liveBand.to_i == @draft.numberOfBands)		#at the end of the round, cycle to new round
  			@newround = (@draft.round.to_i + 1).to_s
  			@draft.update(liveBand: "1", round: @newround)	
	  	else
	  		@draft.update(liveBand: ((@draft.liveBand.to_i)+1).to_s)
	  	end
	end

	def execute_trade(player, band, compBand, bandRound, compBandRound)
	puts "GETS HERE 111"
  	@currentBand = Band.where(number: band).first
  	@compBand = Band.where(number: compBand).first
  	

  	compBandPrevRound = 0
  	prevBandPrevRound = 0
  	

  	if (compBand == 1)
  		#@prevBand = Band.where(number: Draft.first.numberOfBands)
  		@prevBand = Draft.first.numberOfBands
  	else
  		#@prevBand = Band.where(number: (@compBand.number-1)).first
  		@prevBand = compBand - 1
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
  				execute_trade(player, band, @prevBand, bandRound, compBandRound)
  			else
  				@currentBand.update(player4: @compBandPlayer3)
  				@currentBand.save
  				@compBand.update(player3: player)

  				update_draft_round

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
  					execute_trade(player, band, @prevBand, bandRound, (compBandRound-1) )
  				else
  					execute_trade(player, band, @prevBand, bandRound, compBandRound )
  				end
  			else
  				@currentBand.update(player4: @compBandPlayer4)
  				@currentBand.save
  				@compBand.update(player4: player)
  				@compBand.save

  				update_draft_round

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
  				execute_trade(player, band, @prevBand, bandRound, compBandRound)
  			else
  				@currentBand.update(player3: @compBandPlayer2)
  				@currentBand.save
  				@compBand.update(player2: player)

  				update_draft_round

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
  					execute_trade(player, band, @prevBand, bandRound, (compBandRound-1) )
  				else
  					execute_trade(player, band, @prevBand, bandRound, compBandRound )
  				end
  			else
  				@currentBand.update(player3: @compBandPlayer3)
  				@currentBand.save
  				@compBand.update(player3: player)
  				@compBand.save

  				update_draft_round

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
  					execute_trade(player, band, @prevBand, bandRound, (compBandRound-1) )
  				else
  					execute_trade(player, band, @prevBand, bandRound, compBandRound )
  				end
  			else
  				@currentBand.update(player2: @compBandPlayer2)
  				@currentBand.save
  				@compBand.update(player2: player)
  				@compBand.save

  				update_draft_round

  				redirect_to livedraft_path and return
  			end
  		end
  	else
  		redirect_to livedraft_path and return
  	end


  end
end
