class GESTIONEMPRUNT

creation{ANY}
	make

feature{}
	lesemprunts:ARRAY[EMPRUNT]
	mesemprunts:ARRAY[EMPRUNT]
	mesempruntsnonrendu:ARRAY[EMPRUNT]
	mediatheque:MEDIATHEQUE
	iu:IU
	emprunt_path:STRING

feature{ANY}

	make(m:MEDIATHEQUE) is
	do
		emprunt_path := "emprunts.txt"
		mediatheque := m
		init_emprunt
		init_mes_emprunts
		create iu.make
	end

	enter is
	local
		choix:INTEGER
	do
		print_mes_retards
		
		from 
			choix := 1
		until(choix = 0)
		loop
			choix := iu.show_multiple_choice("Effectuer un nouvel emprunt;Afficher mes emprunts;Rendre un média;Afficher mes retards;Afficher les retards","Menu gestion des emprunts")
			inspect choix
			when 1 then
				add_emprunt
			when 2 then
				print_emprunts(mesemprunts, False)
			when 3 then
				rendre_mon_media
			when 4 then
				print_mes_retards
			when 5 then
				print_retards
			else		
			end
		end
	end

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

	add_emprunt is
	local
		choix:STRING
		focus:MEDIA
		emprunt:EMPRUNT
	do
		from
			choix := ""
		until(choix.is_equal("q") or focus /= Void)
		loop
			choix := iu.ask_question("Rechercher un média à emprunter(q pour quitter)")
			focus := mediatheque.get_gestion_media.select_media(choix)
			if(focus /= Void) then
				emprunt := focus.add_emprunt(mediatheque.get_authenticated_user)
				if(emprunt /= Void) then
					lesemprunts.add_last(emprunt)
					mesemprunts.add_last(emprunt)
					save
					io.put_string("Emprunt ajouté")
				end
			end
		end
	end

	save is
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

	rendre_mon_media is
	local
		choix:INTEGER
		emprunt:EMPRUNT
	do
		emprunt := select_emprunt(mesempruntsnonrendu)
		if(emprunt /= Void)then
			if(iu.confirm("Etes vous sur de vouloir rendre "+emprunt.get_media.get_titre+"%N(o pour oui, n pour non)"))then
				emprunt.rendre
				save
			else
				io.put_string("Annulation du retour du média")
			end				
		end
	end

	print_emprunts(liste:ARRAY[EMPRUNT], only_non_rendu:BOOLEAN) is
	local
		i:INTEGER
		displayed:INTEGER
		emprunt:EMPRUNT
	do
		displayed := 0
		from
			i :=  1
		until(i = liste.count)
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

	select_emprunt(liste:ARRAY[EMPRUNT]):EMPRUNT is
	local
		res:EMPRUNT
		choix:STRING
	do
		print_emprunts(liste, False)
		from 
			choix := ""
		until(choix.is_integer and then choix.to_integer <= liste.upper and then choix.to_integer > 0)
		loop
			choix := iu.ask_question("Quel média voulez vous sélectionner")
			if(choix.is_integer and then choix.to_integer <= mesempruntsnonrendu.upper and then choix.to_integer > 0 )then
				res := liste.item(choix.to_integer)
			end
		end
		Result := res
	end
	

end -- class gestionemprunt
