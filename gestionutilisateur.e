class GESTIONUTILISATEUR

creation{ANY}
	make

feature{}
	lesutilisateurs:ARRAY[UTILISATEUR]
	iu:IU

feature{ANY}
	make is
	do
		init_util
		create iu.make
	end

	enter is
	local
		choix:INTEGER
	do
		from 
			choix := 1
		until(choix = 0)
		loop
			choix := iu.show_multiple_choice("Afficher la liste des utilisateurs chargés;Recharger les utilisateurs","Menu gestion des utilisateurs")
			inspect choix
			when 1 then
				afficher_utilisateurs
			when 2 then
				init_util
			else		
			end
		end
	end

	init_util is
		--Chargement des utilisateurs 
	local
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

end -- class GESTIONUTILISATEUR
