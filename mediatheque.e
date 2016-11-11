class MEDIATHEQUE
	--
	-- Le jeu des tours de Hanoi
	--
--
	
creation {ANY}
	make

feature {}
	lesutilisateurs:ARRAY[UTILISATEUR]
	lesmedias:ARRAY[MEDIA]

feature {ANY}
	make is
			-- Creation du jeu et boucle principale
		do
			init_util
			afficher_utilisateurs

			init_media
			afficher_medias
		end
	init_media is
			--Chargement des médias 
		local
			parser:PARSER
		do
			create parser.make
			lesmedias := parser.parse_media("./medias.txt")
			
		end

	init_util is
			--Chargement des utilisateurs 
		local
			nouvel_utilisateur : UTILISATEUR
			parser:PARSER
		do
			create parser.make
			lesutilisateurs := parser.parse_utilisateur("./utilisateurs.txt")
		end

	afficher_utilisateurs is
			--Affichage en liste des utilisateurs chargés
		local
			i:INTEGER
			utilisateur:UTILISATEUR
		do
			
			from
				i := lesutilisateurs.count - 1
			until(i = 1)
			loop
				utilisateur := lesutilisateurs.item(i)
				utilisateur.print_utilisateur
				i := i - 1 
			end

		end
	afficher_medias is
			--Affichage en liste des utilisateurs chargés
		local
			i:INTEGER
			media:MEDIA
		do
			
			from
				i := lesmedias.count - 1
			until(i = 1)
			loop
				media := lesmedias.item(i)
				media.print_media
				i := i - 1 
			end

		end
end -- class HANOI
