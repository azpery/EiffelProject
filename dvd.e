class DVD

inherit MEDIA
	redefine print_media, make end	

creation{ANY}
	 make

feature{}
	annee : STRING
	realisateur: STRING
	acteur:ARRAY[STRING]
	type:STRING

feature{ANY}
	make is
	do
		super_make
		annee := "Pas d'année"
		realisateur := "Pas de réalisateur"
		create acteur.make(0,0)
		type := "Pas de type"
	end

	set_annee (a : STRING) is
	do
		annee := a
	end

	get_annee : STRING is
	do
		Result := annee
	end

	set_realisateur (r : STRING) is
	do
		realisateur := r
	end

	get_realisateur : STRING is
	do
		Result := realisateur
	end

	add_acteur (a : STRING) is
	do
		acteur.add_last(a)
	end

	get_acteur : ARRAY[STRING] is
	do
		Result := acteur
	end

	set_type (r : STRING) is
	do
		type := r
	end

	get_type : STRING is
	do
		Result := type
	end

	print_media is
	do
		
		iu.put_centered_string(titre, '*')
		io.put_string("Année:")
		io.put_string(annee)
		io.put_string("%N")
		io.put_string("Réalisateur:")
		io.put_string(realisateur)
		io.put_string("%N")
		io.put_string("Packaging:")
		io.put_string(type)
		io.put_string("%N")
		print_acteur
	end
	
	print_acteur is
		local
			i:INTEGER
		do
			i := acteur.count - 1
			if(i > 0) then
				io.put_string("Liste des acteurs présents: %N")
			end			
			from
				i := acteur.count - 1
			until(i = 0)
			loop
				io.put_string("- " + acteur.item(i) + "%N")
				i := i - 1 
			end
		end
	




end -- class LIVRE
