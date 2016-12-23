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
