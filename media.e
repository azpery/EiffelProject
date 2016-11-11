class MEDIA
-- Represente un utilisateur de la médiathèque
	
creation {ANY}
	init, make

feature {}
	titre:STRING
	auteur:STRING
	annee:STRING
feature {}
	make is
	do
		titre := "Pas de titre"
		auteur := "Pas d'auteur"
		annee := "Pas d'année"
	end
	init (t:STRING; au:STRING; an:STRING) is
			-- Creation d'un utilisateur
		do
			titre := t
			auteur := au
			annee := an
		end

feature {ANY}
	set_titre(i:STRING) is
		do
			titre := i
		end
	set_auteur(n:STRING) is
		do
			auteur := n
		end
	set_annee(p:STRING) is
		do
			annee := p
		end
	get_titre : STRING is
		do
			Result := titre
		end
	get_auteur : STRING is
		do
			Result := auteur
		end
	get_annee : STRING is
		do
			Result := annee
		end
	print_media is
		do
			io.put_string("Titre:")
			io.put_string(titre)
			io.put_string("%N")
			io.put_string("Auteur:")
			io.put_string(auteur)
			io.put_string("%N")
			io.put_string("Année:")
			io.put_string(annee)
			io.put_string("%N")
		end

end -- class TOWER
