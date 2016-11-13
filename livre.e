class LIVRE

inherit MEDIA
	redefine print_media,make end	

creation{ANY}
	 make

feature{}
	auteur : STRING

feature{ANY}
	make is 
	do
		super_make
		auteur := "Pas d'auteur"
	end

	set_auteur (a : STRING) is
	do
		auteur := a
	end

	get_auteur : STRING is
	do
		Result := auteur
	end

	print_media is
	do
		iu.put_centered_string(titre, '*')
		io.put_string("%N")
		io.put_string("Auteur:")
		io.put_string(auteur)
		io.put_string("%N")
		io.put_string("Nombre d'exemplaire disponibles:")
		io.put_integer(nbexemplaire)
		io.put_string("%N")
	end


end -- class LIVRE
