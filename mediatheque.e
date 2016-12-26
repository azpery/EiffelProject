class MEDIATHEQUE
	--
	-- Gestion d'une médiathèque
	--
--
	
creation {ANY}
	make

feature {}
	gestion_utilisateur:GESTIONUTILISATEUR
	gestion_media:GESTIONMEDIA
	gestion_emprunt:GESTIONEMPRUNT
	utilisateur:UTILISATEUR
	iu:IU

feature {ANY}
	make is
		-- Creation du jeu et boucle principale
	local
		choice:INTEGER
	do
		create gestion_utilisateur.make
		utilisateur := gestion_utilisateur.recherche("anabol","id").item(1)
		create gestion_media.make
		create gestion_emprunt.make(Current)
		create iu.make
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
	end

	print_menu_admin is
	--Menu administrateur
	local
		choice:INTEGER
	do
		gestion_emprunt.print_retards
		iu.put_centered_string("Bienvenue "+utilisateur.get_prenom, '*')
		from 
		choice := 1
		until(choice = 0)
		loop
			choice := iu.show_multiple_choice("Gérer les utilisateurs;Gérer les médias;Gérer les emprunts", "Menu principal")
			inspect choice
			when 1 then
				gestion_utilisateur.enter
			when 2 then
				gestion_media.enter
			when 3 then
				gestion_emprunt.enter
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
		iu.put_centered_string("Bienvenue "+utilisateur.get_prenom, '*')
		from 
		choice := 1
		until(choice = 0)
		loop
			choice := iu.show_multiple_choice("Consulter les médias disponibles à la location;Effectuer un emprunt;Rendre une location;Consulter mes emprunts en cours", "Menu principal")
			inspect choice
			when 1 then
				gestion_media.rechercher_media
			when 2 then
				gestion_emprunt.add_emprunt
			when 3 then
				gestion_emprunt.rendre_mon_media
			when 4 then
				gestion_emprunt.print_emprunts(gestion_emprunt.get_mesemprunts, False)
			else
			
			end
		end	
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
