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
	iu:IU

feature {ANY}
	make is
		-- Creation du jeu et boucle principale
	local
		choice:INTEGER
	do
		create gestion_media.make
		create gestion_utilisateur.make
		create iu.make
		from 
		choice := 1
		until(choice = 0)
		loop
			choice := iu.show_multiple_choice("Gérer les utilisateurs;Gérer les médias", "Menu principal")
			inspect choice
			when 1 then
				gestion_utilisateur.enter
			when 2 then
				gestion_media.enter
			else
			
			end
		end		
	end
end -- class MEDIATHEQUE
