class GESTIONEMPRUNT

creation{ANY}
	make

feature{}
	lesemprunts:ARRAY[EMPRUNT]
	mesemprunts:ARRAY[EMPRUNT]
	lesreservations:ARRAY[RESERVATION]
	mesreservations:ARRAY[RESERVATION]
	mesempruntsnonrendu:ARRAY[EMPRUNT]
	mediatheque:MEDIATHEQUE
	iu:IU
	emprunt_path:STRING
	reservation_path:STRING

feature{ANY}

	make(m:MEDIATHEQUE) is
	require
		mediatheque:m /= Void
	do
		emprunt_path := "emprunts.txt"
		reservation_path := "reservations.txt"
		mediatheque := m
		init_emprunt
		init_mes_emprunts
		init_reservation
		init_mes_reservations
		create iu.make
	end

	enter is
	local
		choix:INTEGER
	do
		print_mes_retards
		check_reservation_available
		from 
			choix := 1
		until(choix = 0)
		loop
			choix := iu.show_multiple_choice("Effectuer un nouvel emprunt;Afficher mes emprunts;Afficher tous les emprunts;Rendre un média;Rendre tous mes médias;Afficher mes retards;Afficher les retards;Afficher mes réservations;Afficher toutes les réservations","Menu gestion des emprunts")
			inspect choix
			when 1 then
				add_emprunt
			when 2 then
				print_emprunts(mesemprunts, False)
			when 3 then
				print_emprunts(lesemprunts, False)
			when 4 then
				rendre_mon_media
			when 5 then
				rendre_tous_mes_medias
			when 6 then
				print_mes_retards
			when 7 then
				print_retards
			when 8 then
				print_reservation(mesreservations)
			when 9 then
				print_reservation(lesreservations)
			else		
			end
		end
	end

	add_emprunt is
	--Méthode  d'ajout d'emprunt
	local
		choix:STRING
		focus:MEDIA
	do
		from
			choix := ""
		until(choix.is_equal("q") or focus /= Void)
		loop
			choix := iu.ask_question("Rechercher un média à emprunter(q pour quitter)")
			focus := mediatheque.get_gestion_media.select_media(choix)
			if(focus /= Void)then
				make_emprunt(focus)
			end
		end
		mesempruntsnonrendu := get_emprunts_non_rendu(mesemprunts)
	end

	check_reservation_available is
	--Vérifie si une des réservations faite par l'utilisateur est de nouveau disponible.
	--Si une des réservation est disponible, on demande s'il veut emprunter le média
	local
		i:INTEGER
		reservation:RESERVATION
		media:MEDIA
		choix:STRING
	do
		from
			i :=  1
		until(i = mesreservations.count)
		loop
			reservation := mesreservations.item(i)
			media := reservation.get_media
			if(media.get_nbexemplaire > 0)then
				choix := iu.ask_question("Vous avez effectué une réservation le "+reservation.get_date_reservation+" du "+media.get_class+" : "+media.get_titre+", il est de nouveau disponible désirez-vous l'emprunter dès aujourd'hui?(o pour oui, n pour non)")
				if(choix.is_equal("o"))then
					remove_reservation(reservation)
					i := mesreservations.count - 1
					make_emprunt(media)
					save_reservations
				end
			end
			i := i + 1 
		end
	end

	make_emprunt(m:MEDIA) is
	--Création d'un emprunt depuis un média
	require
		m_not_void: m /= Void
	local
		emprunt:EMPRUNT
		available:BOOLEAN
	do
		available := is_media_available(m)
		if(available) then
			emprunt := m.add_emprunt(mediatheque.get_authenticated_user)
			if(emprunt /= Void) then
				lesemprunts.add_last(emprunt)
				mesemprunts.add_last(emprunt)
				mesempruntsnonrendu.add_last(emprunt)
				save
				mediatheque.get_gestion_media.save
				io.put_string("Emprunt ajouté")
			else
				if(not did_made_reservation(m) and then iu.confirm("Ce média n'est actuellement pas disponible, mais désirez vous le réserver?(o pour oui)"))then
					make_reservation(m)
				end
			end
		elseif(not available)then
			io.put_string("Désolé, quelqu'un a déjà réservé ce média, vous ne pouvez pas l'emprunter.")
		end
	end

	make_reservation(m:MEDIA)is
	--Création d'une réservation à partir d'un média
	require
		media_not_void: m /= Void
	local
		res:RESERVATION
	do
		if(not did_made_reservation(m))then
			create res.init(mediatheque.get_authenticated_user, m)
			lesreservations.add_last(res)
			mesreservations.add_last(res)
			save_reservations
			io.put_string("Réservation effectuée")
		else
			io.put_string("Quelqu'un a déjà réservé " + m.get_titre)
		end
	end

	did_made_reservation(m:MEDIA):BOOLEAN is
	--Retourne True si uneréservation a été effectuée sur le média.
	require
		media_not_void: m/= Void
	local
		i:INTEGER
		reservation:RESERVATION
		res:BOOLEAN
		other:MEDIA
	do
		res := False
		from
			i :=  1
		until(i = lesreservations.count or res=True)
		loop
			reservation := lesreservations.item(i)
			other := reservation.get_media
			res := other.get_class.is_equal(m.get_class) and then other.is_equals(m)
			i := i + 1 
		end
		Result := res
	end

	did_made_emprunt(e:MEDIA):BOOLEAN is
	--Retourne vrai si un emprunt a été effectué
	require
		emprunt_not_void:e /= Void
	local
		i:INTEGER
		res:BOOLEAN
	do
		res := False
		from
			i :=  1
		until(i >= lesemprunts.count)
		loop
			res := lesemprunts.item(i).get_media.get_class.is_equal(e.get_class) and then lesemprunts.item(i).get_media.is_equals(e) and then not lesemprunts.item(i).get_is_rendu or res
			i := i + 1 
		end
		Result := res
	end

	is_media_available(m:MEDIA):BOOLEAN is
	--Retourne vrai si le média n'est pas sujet à une réservation et qu'il reste plus ou moins d'un exemplaire
	do
		if(did_made_reservation(m))then
			Result := m.get_nbexemplaire > 1
		else
			Result := True
		end
	end
	
	save is
	--Sauvegarde des données dansle fichier 
	local
		res:STRING
		i:INTEGER
		emprunt:EMPRUNT
	do
		res := ""
		from
			i :=  1
		until(i = lesemprunts.count)
		loop
			emprunt := lesemprunts.item(i)
			res := res + emprunt.to_file_string + "%N"
			i := i + 1 
		end
		iu.to_file(emprunt_path, res)
	end

	save_reservations is
	--Sauvegarde des données des réservation dans le fichier 
	local
		res:STRING
		i:INTEGER
		reservation:RESERVATION
	do
		res := ""
		from
			i :=  1
		until(i = lesreservations.count)
		loop
			reservation := lesreservations.item(i)
			res := res + reservation.to_file_string + "%N"
			i := i + 1 
		end
		iu.to_file(reservation_path, res)
	end

	rendre_mon_media is
	--Méthode qui permet de rendre un de ses emprunts
	local
		emprunt:EMPRUNT
	do
		emprunt := select_emprunt(mesempruntsnonrendu, True)
		if(emprunt /= Void)then
			if(iu.confirm("Etes vous sur de vouloir rendre "+emprunt.get_media.get_titre+"%N(o pour oui, n pour non)"))then
				emprunt.rendre
				remove_emprunt_non_rendu(emprunt)
				save
			else
				io.put_string("Annulation du retour du média")
			end				
		end
	end

	rendre_tous_mes_medias is
	--Fonction de rendu de média
	local
		i:INTEGER
	do
		from
			i :=  1
		until(i = mesempruntsnonrendu.count)
		loop
			mesempruntsnonrendu.item(i).rendre
			i := i + 1 
		end
		create mesempruntsnonrendu.make(0,0)
		save
	end

	remove_reservation(r:RESERVATION)is
	local
		i:INTEGER
	do
		from
			i :=  1
		until(i >= lesreservations.count)
		loop
			if(lesreservations.item(i).is_equals(r))then
				lesreservations.remove(i)
				i := lesreservations.count-1
			end
			i := i + 1 
		end
		from
			i :=  1
		until(i = mesreservations.count)
		loop
			if(mesreservations.item(i).is_equals(r))then
				mesreservations.remove(i)
				i := mesreservations.count-1
			end
			i := i + 1 
		end
	end

	remove_emprunt_non_rendu(e:EMPRUNT)is
	local
		i:INTEGER
	do
		from
			i :=  1
		until(i = mesempruntsnonrendu.count)
		loop
			if(mesempruntsnonrendu.item(i).is_equals(e))then
				mesempruntsnonrendu.remove(i)
				i := mesempruntsnonrendu.count-1
			end
			i := i + 1 
		end
	end

	remove_emprunt(e:EMPRUNT)is
	local
		i:INTEGER
	do
		from
			i :=  1
		until(i = lesemprunts.count)
		loop
			if(lesemprunts.item(i).is_equals(e))then
				lesemprunts.remove(i)
				i := lesemprunts.count-1
			end
			i := i + 1 
		end
		from
			i :=  1
		until(i = mesemprunts.count)
		loop
			if(mesemprunts.item(i).is_equals(e))then
				mesemprunts.remove(i)
				i := mesemprunts.count-1
			end
			i := i + 1 
		end
		from
			i :=  1
		until(i = mesempruntsnonrendu.count)
		loop
			if(mesempruntsnonrendu.item(i).is_equals(e))then
				mesempruntsnonrendu.remove(i)
				i := mesempruntsnonrendu.count-1
			end
			i := i + 1 
		end
	end

	print_reservation(liste:ARRAY[RESERVATION]) is
	local
		i:INTEGER
		reservation:RESERVATION
	do
		from
			i :=  1
		until(i = liste.count)
		loop
			reservation := liste.item(i)
			io.put_string("%N" + i.to_string + "-")
			reservation.to_string
			i := i + 1 
		end
	end

	print_emprunts(liste:ARRAY[EMPRUNT]; only_non_rendu:BOOLEAN) is
	local
		i:INTEGER
		displayed:INTEGER
		emprunt:EMPRUNT
	do
		displayed := 0
		from
			i :=  1
		until(i >= liste.count)
		loop
			emprunt := liste.item(i)
			if(only_non_rendu and not emprunt.get_is_rendu or not only_non_rendu) then
				io.put_string("%N" + i.to_string + "-")
				emprunt.to_string(iu)
				displayed := displayed + 1
			end
			i := i + 1 
		end
		if(displayed = 0)then
			io.put_string("Aucun emprunt trouvé")
		end
	end

	get_mesemprunts:ARRAY[EMPRUNT] is
	do
		Result := mesemprunts
	end

	get_mesreservations:ARRAY[RESERVATION] is
	do
		Result := mesreservations
	end


	print_retards is
		--Affichage des emprunts en retard
	local
		i:INTEGER
		emprunt:EMPRUNT
	do
		from
			i :=  1
		until(i = lesemprunts.count)
		loop
			emprunt := lesemprunts.item(i)
			if(emprunt.is_retard and not emprunt.get_is_rendu)then
				io.put_string(emprunt.get_utilisateur.get_prenom+" "+emprunt.get_utilisateur.get_nom+" a emprunté "+ emprunt.get_media.get_titre + " le "+ emprunt.get_date_emprunt + ". Il a donc " +emprunt.get_nb_jour_retard.to_string +" jours de retard%N")
				if(did_made_reservation(emprunt.get_media))then
					io.put_string("De plus, quelqu'un a effectué une reservation sur ce média.%N")
				end
				
			end
			i := i + 1 
		end
	end

	print_mes_retards is
		--Affichage des emprunts en retard
	local
		i:INTEGER
		emprunt:EMPRUNT
	do
		from
			i :=  1
		until(i = mesemprunts.count)
		loop
			emprunt := mesemprunts.item(i)
			if(emprunt.is_retard and not emprunt.get_is_rendu)then
				io.put_string("Vous avez emprunté "+ emprunt.get_media.get_titre + " le "+ emprunt.get_date_emprunt + ". vous avez donc " +emprunt.get_nb_jour_retard.to_string +" jours de retard%N")
			end
			i := i + 1 
		end
	end

	select_emprunt(liste:ARRAY[EMPRUNT]; emprunt:BOOLEAN):EMPRUNT is
	local
		res:EMPRUNT
		choix:STRING
	do
		print_emprunts(liste, emprunt)
		if(liste.count>0)then
			io.put_string("%Nq pour annuler")
			from 
				choix := ""
			until(choix.is_integer and then choix.to_integer <= liste.upper and then choix.to_integer > 0 or choix.is_equal("q"))
			loop
				choix.copy(iu.ask_question("Quel emprunt voulez vous sélectionner"))
				if(choix.is_integer and then choix.to_integer <= mesempruntsnonrendu.upper and then choix.to_integer > 0 )then
					res := liste.item(choix.to_integer)
				end
			end
		end
		Result := res
	end
	
	--INITIALISATIONS
	
	init_emprunt is
		--Chargement des emprunts 
	local
		parser:PARSER
	do
		create parser.make
		lesemprunts := parser.parse_emprunt(emprunt_path, mediatheque.get_gestion_utilisateur, mediatheque.get_gestion_media)
	end

	init_mes_emprunts is
		--Chargement des emprunts 
	local
		i:INTEGER
		emprunt:EMPRUNT
		id:STRING
	do
		id := mediatheque.get_authenticated_user.get_id
		create mesemprunts.make(0,0)
		from
			i :=  1
		until(i = lesemprunts.count)
		loop
			emprunt := lesemprunts.item(i)
			if(emprunt.get_utilisateur.get_id.is_equal(id))then
				mesemprunts.add_last(emprunt)
			end
			i := i + 1 
		end
		mesempruntsnonrendu := get_emprunts_non_rendu(mesemprunts)
	end

	init_reservation is
		--Chargement des réservations 
	local
		parser:PARSER
	do
		create parser.make
		lesreservations := parser.parse_reservation(reservation_path, mediatheque.get_gestion_utilisateur, mediatheque.get_gestion_media)
	end

	init_mes_reservations is
		--Chargement de mes réservations 
	local
		i:INTEGER
		reservation:RESERVATION
		id:STRING
	do
		id := mediatheque.get_authenticated_user.get_id
		create mesreservations.make(0,0)
		from
			i :=  1
		until(i = lesreservations.count)
		loop
			reservation := lesreservations.item(i)
			if(reservation.get_utilisateur.get_id.is_equal(id))then
				mesreservations.add_last(reservation)
			end
			i := i + 1 
		end
	end

	get_emprunts_non_rendu(liste:ARRAY[EMPRUNT]):ARRAY[EMPRUNT] is
	local
		res:ARRAY[EMPRUNT]
		emprunt:EMPRUNT
		i:INTEGER
	do
		create res.make(0,0)
		from
			i :=  1
		until(i = liste.count)
		loop
			emprunt := liste.item(i)
			if(not emprunt.get_is_rendu) then
				res.add_last(emprunt)
			end
			i := i + 1 
		end
		Result := res
	end

	get_all_emprunts:ARRAY[EMPRUNT] is
	do
		Result := lesemprunts
	end

	get_resa:ARRAY[RESERVATION] is
	do
		Result := lesreservations
	end

	get_emprunt_en_cours(liste:ARRAY[EMPRUNT]):ARRAY[EMPRUNT] is
	local
		i:INTEGER
		empruntencours:ARRAY[EMPRUNT]
		emprunt:EMPRUNT	
	do
		create empruntencours.make(0,0)
		from
			i:=1
		until(i = liste.count)
		loop
			emprunt := liste.item(i)
			if(emprunt.get_is_rendu)then
				
			else
				empruntencours.add_last(emprunt)
				
			end
		i := i + 1		
		end
		
		Result := empruntencours
	end


	get_emprunt_en_retard(liste:ARRAY[EMPRUNT]):ARRAY[EMPRUNT] is
	local
		i:INTEGER
		enretard:ARRAY[EMPRUNT]
		emprunt:EMPRUNT	
	do
		create enretard.make(0,0)
		from
			i:=1
		until(i = liste.count)
		loop
			emprunt := liste.item(i)
			if(emprunt.is_retard and not emprunt.get_is_rendu)then
				enretard.add_last(emprunt)
			else
			end
		i := i + 1
		end
		Result := enretard
	end

end -- class gestionemprunt
