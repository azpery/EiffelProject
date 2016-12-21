class EMPRUNT
-- Represente un emprunt de la médiathèque

creation{ANY}
	 make, init

feature {}
	media:MEDIA
	utilisateur:UTILISATEUR
	date_emprunt,date_retour:TIME
	is_rendu:BOOLEAN


feature {ANY}
	make is
	do
		date_emprunt.update
		update_date_retour
	end

	init(u:UTILISATEUR; m:MEDIA) is
	do
		media := m
		utilisateur := u
		date_emprunt.update
		update_date_retour
	end
	
	set_is_rendu(ir:BOOLEAN) is
	do
		is_rendu := ir
	end
	
	get_is_rendu:BOOLEAN is
	do
		Result := is_rendu
	end

	set_annee_emprunt(a:INTEGER) is
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(a, date_emprunt.month, date_emprunt.day, 12, 0, 0)
	end

	set_jour_emprunt(j:INTEGER) is
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(date_emprunt.year, date_emprunt.month, j, 12, 0, 0)
	end

	set_mois_emprunt(m:INTEGER) is
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(date_emprunt.year, m, date_emprunt.day, 12, 0, 0)
	end

	set_date_emprunt(a:INTEGER; m:INTEGER; j:INTEGER)is
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(a, m, j, 12, 0, 0)
	end

	get_date_emprunt:STRING is
	do
		Result := date_emprunt.day.to_string +"/"+date_emprunt.month.to_string+"/"+ date_emprunt.year.to_string
	end

	get_date_retour:STRING is
	do
		Result := date_retour.day.to_string +"/"+date_retour.month.to_string+"/"+ date_retour.year.to_string
	end

	set_utilisateur(u:UTILISATEUR) is
	do
		utilisateur := u
	end

	set_media(m:MEDIA) is
	do
		media := m
	end
	
	update_date_retour is
	do
		date_retour := date_emprunt
		date_retour.add_day(30)
	end

	is_rendu_to_string:STRING is
	local
		res:STRING
	do
		if(is_rendu)then
			res:= "1"
		else
			res := "0"
		end
		Result := res
	end

	to_string_export:STRING is
	local
		res:STRING
	do
		res := "utilisateur<"+utilisateur.get_id+"> ; media<"+media.get_id+"> ; isrendu<"+is_rendu_to_string+"> ; annee_emprunt<"+date_emprunt.year.to_string+"> ; jour_emprunt<"+date_emprunt.day.to_string+"> ; mois_emprunt<"+date_emprunt.month.to_string+">"
		Result := res
	end
	

end -- class EMPRUNT
