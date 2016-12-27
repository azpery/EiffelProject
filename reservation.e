class RESERVATION
-- Represente une réservation d'un média de la médiathèque

creation{ANY}
	 make, init

feature {}
	media:MEDIA
	utilisateur:UTILISATEUR
	date_reservation,date_fin:TIME

feature {ANY}
	make is
	do
		date_reservation.update
		update_date_fin
	end

	init(u:UTILISATEUR; m:MEDIA) is
	do
		media := m
		utilisateur := u
		date_reservation.update
		update_date_fin
	end
	
	update_date_fin is
	do
		date_fin := date_reservation
		date_fin.add_day(30)
	end
	
	to_file_string:STRING is
	local
		res:STRING
	do
		res := "utilisateur<"+utilisateur.get_id+"> ; media<"+media.get_id+"> ; annee_reservation<"+date_reservation.year.to_string+"> ; jour_reservation<"+date_reservation.day.to_string+"> ; mois_reservation<"+date_reservation.month.to_string+">"
		Result := res
	end

	to_string is
	--Affichage de la réservation
	do
		io.put_string("Vous avez effectué une réservation pour le "+media.get_class+" : "+media.get_titre+" le "+get_date_reservation)
		
	end

	is_equals(r:RESERVATION):BOOLEAN is
	--retourner vrai s'il s'agit de la même réservation	
	local
		res:BOOLEAN
	do
		res := False
		if(r.get_media.get_class.is_equal(media.get_class) and then r.get_media.is_equals(media) and then utilisateur.get_id.is_equal(r.get_utilisateur.get_id)) then
			res := True
		end
		Result := res
	end

	is_still_available:BOOLEAN is
	--Méthode qui vérifie si la réservation est toujours valable
	local
		res:BOOLEAN
		now:TIME
	do
		now.update
		res:=False
		if(now < date_fin)then
			res := True
		end
		Result := res
	end

	--GETTER SETTER
	set_annee_reservation(a:INTEGER) is
	local
		res:BOOLEAN
	do
		res := date_reservation.set(a, date_reservation.month, date_reservation.day, 12, 0, 0)
	end

	set_jour_reservation(j:INTEGER) is
	require 
		jour_correct:j>0 and j<=31
	local
		res:BOOLEAN
	do
		res := date_reservation.set(date_reservation.year, date_reservation.month, j, 12, 0, 0)
	end

	set_mois_reservation(m:INTEGER) is
	require 
		mois_correct:m>0 and m<=12
	local
		res:BOOLEAN
	do
		res := date_reservation.set(date_reservation.year, m, date_reservation.day, 12, 0, 0)
	end

	set_date_reservation(a:INTEGER; m:INTEGER; j:INTEGER)is
	local
		res:BOOLEAN
	do
		res := date_reservation.set(a, m, j, 12, 0, 0)
	end

	get_date_reservation:STRING is
	do
		Result := date_reservation.day.to_string +"/"+date_reservation.month.to_string+"/"+ date_reservation.year.to_string
	end

	get_date_fin:STRING is
	do
		Result := date_fin.day.to_string +"/"+date_fin.month.to_string+"/"+ date_fin.year.to_string
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
	do
		utilisateur := u
	end

	set_media(m:MEDIA) is
	do
		media := m
	end

end -- class reservation
