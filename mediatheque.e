class MEDIATHEQUE
	--
	-- Gestion d'une médiathèque
	--
--
	
creation {ANY}
	make, init

feature {}
	gestion_utilisateur:GESTIONUTILISATEUR
	gestion_media:GESTIONMEDIA
	gestion_emprunt:GESTIONEMPRUNT
	statistique:STATISTIQUE
	utilisateur:UTILISATEUR
	iu:IU

feature {ANY}
	init(id:STRING;nom:STRING) is
	local
		logsvalide:BOOLEAN
		i:INTEGER
	do
		create gestion_utilisateur.make
		create iu.make
		logsvalide := False
		if(not id.is_empty and not nom.is_empty and then gestion_utilisateur.recherche(id,"id").count > 1)then
			from
				i := gestion_utilisateur.recherche(id,"id").count - 1
			until(i = 0 or logsvalide)
			loop
				
				utilisateur := gestion_utilisateur.recherche(id,"id").item(i)
				logsvalide := utilisateur.get_nom.is_equal(nom)
				i := i - 1					
			end
			create gestion_media.make(Current)
			create gestion_emprunt.make(Current)
			create statistique.make(Current)
		
		else
				
		end
	end
	make is
		-- Creation du jeu et boucle principale
	local
		choice:INTEGER
		logsvalide:BOOLEAN
		id, nom:STRING
		i:INTEGER
	do
		id := ""
		nom := ""
		create gestion_utilisateur.make
		create iu.make
		from
			logsvalide := False
		until(logsvalide)
		loop
			iu.put_centered_string("BIENVENUE DANS LA MEDIATHEQUE", '*')
			id.copy(iu.ask_question("Veuillez vous authentifier:%N (Si vous n'avez pas de comptes, vous pouvez acceder à la consultation des médias en entrant l'identifiant: visiteur) %NIdentifiant"))
			
			if(gestion_utilisateur.recherche(id,"id").count > 1)then
				nom.copy(iu.ask_question("Nom"))
				from
					i := gestion_utilisateur.recherche(id,"id").count - 1
				until(i = 0 or logsvalide)
				loop
					
					utilisateur := gestion_utilisateur.recherche(id,"id").item(i)
					if(utilisateur.get_nom.is_equal(nom)) then
						logsvalide := True
						
					else	
						
					end
					i := i - 1					
				end				
				if(logsvalide) then
					io.put_string("Authentification réussie" + "%N")
				else
					io.put_string("Combinaison login/Nom invalide" + "%N")
				end
			elseif(id.is_equal("visiteur"))then
				nom.copy("visiteur")
				print_menu_visiteur			
			else				
				io.put_string("Identifiant invalide" + "%N")
			end
					
			
		end
		--utilisateur := gestion_utilisateur.recherche("anabol","id").item(1)
		create gestion_media.make(Current)
		create gestion_emprunt.make(Current)
		create statistique.make(Current)
		if(utilisateur.get_isadmin)then
			from 
			choice := 1
			until(choice = 0)
			loop
				choice := iu.show_multiple_choice("Interface utilisateur;Administration de la médiathèque", "Choix de rôle")
				inspect choice
				when 1 then
					print_menu_utilisateur
				when 2 then
					print_menu_admin
				else
					
				end
			end
		else	
			print_menu_utilisateur
		end
		iu.put_centered_string("A bientôt "+utilisateur.get_prenom, ' ')
	end

	print_menu_admin is
	--Menu administrateur
	local
		choice:INTEGER
		p:PARSER
	do
		create p.make
		gestion_emprunt.print_retards
		iu.put_centered_string("Bienvenue "+utilisateur.get_prenom, '*')
		from 
		choice := 1
		until(choice = 0)
		loop
			choice := iu.show_multiple_choice("Gérer les utilisateurs;Gérer les médias;Gérer les emprunts;Statistiques;Accéder au tests unitaires", "Menu principal")
			inspect choice
			when 1 then
				gestion_utilisateur.enter
			when 2 then
				gestion_media.enter
			when 3 then
				gestion_emprunt.enter
			when 4 then
				statistique.enter
			when 5 then
				test
			when 6 then
				p.not_bad
			else
			
			end
		end	
	end
	
	print_menu_utilisateur is
	--Menu utilisateur
	local
		choice:INTEGER
	do
		gestion_emprunt.print_mes_retards
		gestion_emprunt.check_reservation_available 
		iu.put_centered_string("Bienvenue "+utilisateur.get_prenom, '*')
		from 
		choice := 1
		until(choice = 0)
		loop
			choice := iu.show_multiple_choice("Consulter les médias disponibles à la location;Effectuer un emprunt;Rendre une location;Consulter mes emprunts en cours;Consulter mes réservations en cours", "Menu principal")
			inspect choice
			when 1 then
				gestion_media.rechercher_media
			when 2 then
				gestion_emprunt.add_emprunt
			when 3 then
				gestion_emprunt.rendre_mon_media
			when 4 then
				gestion_emprunt.print_emprunts(gestion_emprunt.get_mesemprunts, False)
			when 5 then
				gestion_emprunt.print_reservation(gestion_emprunt.get_mesreservations)
			else
			
			end
		end	
	end

	print_menu_visiteur is
	local
		choice:INTEGER
	do
		create gestion_media.make(Current)
		iu.put_centered_string("Bienvenue visiteur", '*')
		from
			choice := 1
		until(choice = 0)
		loop
			choice := iu.show_multiple_choice("Consulter les médias disponibles à la location", "Menu principal")
			inspect choice
			when 1 then
				gestion_media.consulter_media
			else
			end
		end	
	end

	test is
	local
		emprunt:UTEMPRUNT
		media:UTMEDIA
		mediat:UTMEDIATHEQUE
		user:UTUSER
	do
		create emprunt.main
		create media.main(iu)
		create mediat.main(iu)
		create user.main(iu)
	end

	get_gestion_media:GESTIONMEDIA is
	do
		Result := gestion_media
	end

	get_gestion_utilisateur:GESTIONUTILISATEUR is
	do
		Result := gestion_utilisateur
	end

	get_gestion_emprunt:GESTIONEMPRUNT is
	do
		Result := gestion_emprunt
	end

	get_authenticated_user:UTILISATEUR is
	do
		Result := utilisateur
	end
	
end -- class MEDIATHEQUE
