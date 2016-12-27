class EMPRUNT
-- Represente un emprunt de la médiathèque

creation{ANY}
	 make, init

feature {}
	media:MEDIA
	utilisateur:UTILISATEUR
	date_emprunt,date_retour, date_rendu:TIME
	is_rendu:BOOLEAN


feature {ANY}
	make is
	do
		date_emprunt.update
		update_date_retour
		date_rendu := date_emprunt
		is_rendu := False
	end

	init(u:UTILISATEUR; m:MEDIA) is
	do
		media := m
		utilisateur := u
		date_emprunt.update
		date_rendu := date_emprunt
		update_date_retour
	end
	
	update_date_retour is
	--Rajoute 30 jours à la date de l'emprunt afin d'obtenir la date de rendu 
	do
		date_retour := date_emprunt
		date_retour.add_day(30)
	ensure
		date_did_add: date_retour > date_emprunt
	end

	is_rendu_to_string:STRING is
	--Renvoie 1 ou 0 selon si le média a été rendu
	local
		res:STRING
	do
		if(is_rendu)then
			res:= "1"
		else
			res := "0"
		end
		Result := res
	ensure
		result_correct:Result = "1" or Result = "0"
	end
	
	is_retard:BOOLEAN is
	--Retourne vrai si la date de retour théorique a dépassée la date actuelle
	local
		now:TIME
	do
		now.update
		Result := is_rendu and then date_retour < date_rendu or not is_rendu and then now > date_retour 
	end

	get_nb_jour_retard:INTEGER is
	--Retourne le nombre de jour de retard
	local
		now:TIME
		res:REAL
	do
		now.update
		if(not is_rendu)then
			res := date_retour.elapsed_seconds(now) / 3600 / 24
		else
			res := date_retour.elapsed_seconds(date_rendu) / 3600 / 24
		end
		Result := res.floor.force_to_integer_32
	ensure
		positive: Result >= 0
	end
		
	is_equals(r:EMPRUNT):BOOLEAN is
	--retourner vrai s'il s'agit du même emprunt
	do
		Result := r.get_media.get_class.is_equal(media.get_class) and then r.get_media.is_equals(media) and then utilisateur.get_id.is_equal(r.get_utilisateur.get_id) and then r.get_date_emprunt.is_equal(get_date_emprunt)
	end

	to_string(iu:IU) is
	local
		res:STRING
	do
		iu.put_centered_string(media.get_titre, '*')
		res := "Date d'emprunt: "+get_date_emprunt
		if(is_rendu and is_retard)then
			res := res + "%NDate de retour effective:"+ get_date_rendu+"%N"+ get_nb_jour_retard.to_string + " jours de retard"
		elseif(is_rendu)then
			res := res + "%NDate de retour effective:"+ get_date_rendu
		else
			res := res + "%NDate de retour prévue:"+ get_date_retour
		end
		io.put_string(res)
	end

	to_string_full(iu:IU) is
	do		
		to_string(iu)
		utilisateur.print_utilisateur
		
	end

	to_file_string:STRING is
	local
		res:STRING
	do
		res := "utilisateur<"+utilisateur.get_id+"> ; media<"+media.get_id+"> ; isrendu<"+is_rendu_to_string+"> ; annee_emprunt<"+date_emprunt.year.to_string+"> ; jour_emprunt<"+date_emprunt.day.to_string+"> ; mois_emprunt<"+date_emprunt.month.to_string+">"
		if(is_rendu)then
			res := res + "; annee_retour<"+date_rendu.year.to_string+"> ; jour_retour<"+date_rendu.day.to_string+"> ; mois_retour<"+date_rendu.month.to_string+">"
		end
		Result := res
	end

	rendre is
	--Méthode qui permet de rendre un média
	local
		now:TIME
	do
		now.update
		date_rendu := now
		media.set_nbexemplaire(media.get_nbexemplaire + 1)
		is_rendu := True
	end
	
	--GETTER SETTER
	set_is_rendu(ir:BOOLEAN) is
	do
		is_rendu := ir
	end
	
	get_is_rendu:BOOLEAN is
	do
		Result := is_rendu
	end

	set_annee_rendu(a:INTEGER) is
	local
		res:BOOLEAN
	do
		res := date_rendu.set(a, date_rendu.month, date_rendu.day, 12, 0, 0)
	end

	set_jour_rendu(j:INTEGER) is
	require 
		jour_correct:j>0 and j<=31
	local
		res:BOOLEAN
	do
		res := date_rendu.set(date_rendu.year, date_rendu.month, j, 12, 0, 0)
	end

	set_mois_rendu(m:INTEGER) is
	require
		mois_correct:m>0 and m<=12
	local
		res:BOOLEAN
	do
		res := date_rendu.set(date_rendu.year, m, date_rendu.day, 12, 0, 0)
	end

	set_annee_emprunt(a:INTEGER) is
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(a, date_emprunt.month, date_emprunt.day, 12, 0, 0)
	end

	set_jour_emprunt(j:INTEGER) is
	require 
		jour_correct:j>0 and j<=31
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(date_emprunt.year, date_emprunt.month, j, 12, 0, 0)
	end

	set_mois_emprunt(m:INTEGER) is
	require
		mois_correct:m>0 and m<=12
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(date_emprunt.year, m, date_emprunt.day, 12, 0, 0)
	end

	set_date_emprunt(a:INTEGER; m:INTEGER; j:INTEGER)is
	require
		mois_correct:m>0 and m<=12
		jour_correct:j>0 and j<=31
	local
		res:BOOLEAN
	do
		res := date_emprunt.set(a, m, j, 12, 0, 0)
	end

	get_date_emprunt:STRING is
	do
		Result := date_emprunt.day.to_string +"/"+date_emprunt.month.to_string+"/"+ date_emprunt.year.to_string
	end

	get_date_time_emprunt:TIME is
	do
		Result := date_emprunt
	end

	get_date_retour:STRING is
	do
		Result := date_retour.day.to_string +"/"+date_retour.month.to_string+"/"+ date_retour.year.to_string
	end

	get_date_rendu:STRING is
	do
		Result := date_rendu.day.to_string +"/"+date_rendu.month.to_string+"/"+ date_rendu.year.to_string
	end

	get_utilisateur:UTILISATEUR is
	do
		Result := utilisateur
	end

	get_media:MEDIA is
	do
		Result := media
	end

	set_utilisateur(u:UTILISATEUR) is
	require 
		not_void: u /= Void
	do
		utilisateur := u
	end

	set_media(m:MEDIA) is
	require 
		not_void: u /= Void
	do
		media := m
	end

end -- class EMPRUNT
