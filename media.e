class MEDIA
-- Represente un utilisateur de la médiathèque
	
creation {ANY}
	init, make

feature {}
	titre:STRING
	nbexemplaire:INTEGER
	iu:IU
feature {}
	super_make is
	do
		titre := "Pas de titre"
		nbexemplaire := 0
		create iu.make
	end
	make is
	do
		titre := "Pas de titre"
		nbexemplaire := 0
		create iu.make
	end
	init (t:STRING; an:STRING; nb:INTEGER) is
			-- Creation d'un utilisateur
		do
			titre := t
			nbexemplaire := nb
		end

feature {ANY}
	set_titre(i:STRING) is
		do
			titre := i
		end
	get_titre : STRING is
		do
			Result := titre
		end

	set_nbexemplaire(p:INTEGER) is
		do
			nbexemplaire := p
		end
	get_nbexemplaire : INTEGER is
		do
			Result := nbexemplaire
		end
	print_media is
	do
		io.put_string("Titre:")
		io.put_string(titre)
		io.put_string("%N")
		io.put_string("Nombre d'exemplaire disponibles:")
		io.put_integer(nbexemplaire)
		io.put_string("%N")
	end

end -- class TOWER
