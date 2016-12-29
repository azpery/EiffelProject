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
			choix := iu.show_multiple_choice("Afficher la liste des utilisateurs chargés;Recharger les utilisateurs;Ajouter un utilisateur;Rechercher un utilisateur; Modifier un utilisateur","Menu gestion des utilisateurs")
			inspect choix
			when 1 then
				afficher_utilisateurs
			when 2 then
				init_util
			when 3 then
				ajouter_utilisateur
			when 4 then
				rechercher_utilisateurs
			when 5 then 
				recherche_modif
			else		
			end
		end
	end

	get_all_user:ARRAY[UTILISATEUR] is
	do
		Result:=lesutilisateurs
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
			i := 1
		until(i = lesutilisateurs.count)
		loop
			utilisateur := lesutilisateurs.item(i)
			utilisateur.print_utilisateur
			i := i + 1 
		end

	end





	ajouter_utilisateur is
		--Ajouter un utilisateur
	local
		nom:STRING
		prenom:STRING
		id:STRING
		rep:STRING
		isa:BOOLEAN
		utilisateur:UTILISATEUR
		
	do
		prenom:=""
		nom:=""
		id:=""
		rep:=""
		io.put_string("Entrez le login du nouvel utilisateur:")
		io.put_string("%N")
		io.read_line
		id.copy(io.last_string)
		io.put_string("Entrez le nom du nouvel utilisateur:")
		io.put_string("%N")
		io.read_line
		nom.copy(io.last_string)
		io.put_string("Entrez le prénom du nouvel utilisateur:")
		io.put_string("%N")
		io.read_line
		prenom.copy(io.last_string)
		io.put_string("L'utilisateur est-il un administrateur? 1: oui, 2: non:")
		io.put_string("%N")
		io.read_line
		rep.copy(io.last_string)
		if(rep.is_equal("1")) then
			isa:=True
		else
			isa:=False
		end
		create utilisateur.init(id, nom, prenom, isa)
		io.put_string(utilisateur.get_nom)
		lesutilisateurs.add_last(utilisateur)
		exporter_utilisateur
		io.put_string("Utilisateur correctement ajouté")
		
	end

	rechercher_utilisateurs is
		--Recherche d'un utilisateur
	local	
		choix:INTEGER
		type:STRING
		terme:STRING
		utilisateur:UTILISATEUR
		resultat_recherche:ARRAY[UTILISATEUR]
		j:INTEGER
	do
		create utilisateur.make
		create resultat_recherche.make(0,0)
		choix := iu.show_multiple_choice("Login;Nom;Prénom","Rechercher par:")
		inspect choix
		when 1 then
			type:="id"
		when 2 then
			type:="nom"
		when 3 then
			type:="prenom"
		else		
		end
	
		io.put_string("Veuillez saisir le terme de la recherche:")
		io.read_line
		terme:=io.last_string
		
		resultat_recherche := recherche(terme, type)
		
		if(resultat_recherche.count = 1)then
			io.put_string("Aucun résultat pour la recherche")		
		else
			from
			j := 1
			until(j = resultat_recherche.count)
			loop
				utilisateur := resultat_recherche.item(j)
				io.put_integer(j)
				io.put_string(":")	
				utilisateur.print_utilisateur
				j := j + 1 
			end	
		end
		
		
		
	end

	recherche(terme:STRING; type:STRING):ARRAY[UTILISATEUR] is
	local
		i:INTEGER
		resultat_recherche:ARRAY[UTILISATEUR]
		utilisateur:UTILISATEUR
	do
		create resultat_recherche.make(0,0)
		
		from
			i := lesutilisateurs.upper
		until(i = lesutilisateurs.lower)
		loop
			utilisateur := lesutilisateurs.item(i)
			if(type.is_equal("id"))then
				
				if(terme.is_equal(utilisateur.get_id))then
					resultat_recherche.add_last(utilisateur)
				else
					
				end
			elseif(type.is_equal("nom"))then
				if(terme.is_equal(utilisateur.get_nom))then
					resultat_recherche.add_last(utilisateur)
				else
					
				end
			else
				if(terme.is_equal(utilisateur.get_prenom))then
					resultat_recherche.add_last(utilisateur)
				else
					
				end
				
			end
			i := i - 1 
		end
		Result := resultat_recherche
	end



	recherche_modif is
	local
		resultat_recherche:ARRAY[UTILISATEUR]
		terme, type:STRING
		choix:INTEGER
		utilisateur:UTILISATEUR
	do
		
		from
			choix := 1
		until(choix=0)
		loop
			create utilisateur.make
			create resultat_recherche.make(0,0)
			choix := iu.show_multiple_choice("Login; Nom; Prénom;","Rechercher par:")
			inspect choix
				when 1 then
					type:="id"
					io.put_string("Veuillez saisir le terme de la recherche:")
					io.read_line
					terme:=io.last_string		
					resultat_recherche := recherche(terme, type)
					modifier_utilisateurs(resultat_recherche)
				when 2 then
					type:="nom"
					io.put_string("Veuillez saisir le terme de la recherche:")
					io.read_line
					terme:=io.last_string		
					resultat_recherche := recherche(terme, type)
					modifier_utilisateurs(resultat_recherche)
				when 3 then
					type:="prenom"
					io.put_string("Veuillez saisir le terme de la recherche:")
					io.read_line
					terme:=io.last_string		
					resultat_recherche := recherche(terme, type)
					modifier_utilisateurs(resultat_recherche)
				else		
			end
		
		end
		exporter_utilisateur	
	end




	modifier_utilisateurs(resultat_recherche: ARRAY[UTILISATEUR]) is
	local
		var, choixstr:STRING
		choix, c, j:INTEGER
		isa:BOOLEAN
		utilisateur:UTILISATEUR
	do	

		if(resultat_recherche.count = 1)then
			io.put_string("Aucun résultat pour la recherche")
		else
			from
				j := 1
			until(j = resultat_recherche.count)
			loop
				utilisateur := resultat_recherche.item(j)
				io.put_integer(j)
				io.put_string(":")	
				utilisateur.print_utilisateur
				j := j + 1 
			end
			choixstr := iu.ask_question("Quel utilisateur voulez-vous modifier?(q pour quitter)")
			choix:=choixstr.to_integer
			if(choix <= resultat_recherche.upper)then
				
				from
					c := 1
				until(c=0)
				loop
					c := iu.show_multiple_choice("Modifier le login;Modifier le prénom;Modifier le nom;Modifier le type Admin","Modification de ")
					inspect c
						when 1 then
							var:=""
							io.put_string("Entrez le nouveau login:")
							io.put_string("%N")
							io.read_line
							var.copy(io.last_string)
							resultat_recherche.item(choix).set_id(var)
						when 2 then 
							var:=""
							io.put_string("Entrez le nouveau prénom:")
							io.put_string("%N")
							io.read_line
							var.copy(io.last_string)
							resultat_recherche.item(choix).set_prenom(var)
						when 3 then 
							var:=""
							io.put_string("Entrez le nouveau nom:")
							io.put_string("%N")
							io.read_line
							var.copy(io.last_string)
							resultat_recherche.item(choix).set_nom(var)
						when 4 then 
							var:=""
							io.put_string("Admin ou non? (Entrez 1 pour admin, 2 sinon)")
							io.put_string("%N")
							io.read_line
							var.copy(io.last_string)
							if(var.is_equal("1")) then
								isa:=True
							else
								isa:=False
							end
							resultat_recherche.item(choix).set_isadmin(isa)

						else
					end
				end
			end
		end
		
	end



	exporter_utilisateur is
	local
		res:STRING
		i:INTEGER
		utilisateur:UTILISATEUR
	do
		res := ""
		from
			i := 1
		until(i = lesutilisateurs.count)
		loop
			utilisateur := lesutilisateurs.item(i)
			io.put_string(utilisateur.get_nom)
			io.put_string(i.to_string)
			res := res + utilisateur.to_file_string + "%N"
			i := i + 1 
		end
		iu.to_file("utilisateurs.txt", res)
	end





end -- class GESTIONUTILISATEUR
