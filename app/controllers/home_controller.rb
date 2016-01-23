class HomeController < InheritedResources::Base

  def livedraft
  end

  def bands
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
  	redirect_to livedraft_path
  end

  def test_for_trade(player, band, round)

  	#look at previous band

  	#check how many people in this band

  	#store last player in variable

  	#check if current


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
  	@band = Band.where(number: @draft.liveBand.to_i).first
  end

end