File.open('kk','w') do |f| f.print 'hi' end
f = ARGV[0]
n = f.length
if f.match(/.csv$/) != nil
    # if  n == "*.csv"
    # Abre y lee un fichero
    	File.open(f [0..-5].downcase + '.pl', 'w') do |f2|
    		File.open(f, 'r') do |f1|
                name = f [0..-5].downcase.split("/")[-1]
		    	f2.puts ':- module(' + name + ' ,_, [rfuzzy, clpr]).'
		    	linea = f1.gets 
		    	str_ary = linea.split(",")
		    	f2.print 'define_database(' + name + '/' + str_ary.length.to_s + ",\n["
                if str_ary[0..str_ary.length-1].length != ARGV[1..-1].length 
                   puts "Error, hay que meter tantos argumentos como columnas tenga el csv"
                   exit(1)
                end
		    	str_ary[0..str_ary.length-2].zip ARGV[1..-2].each do |str, type|
		    		f2.puts '(' + str.downcase + ', rfuzzy_' + type + '_type),'
               end
		    	f2.puts '(' + str_ary[str_ary.length-1][0..-2].downcase + ', rfuzzy_' + ARGV[-1] + "_type)]).\n\n"
		    	while linea = f1.gets
		    		if (linea != "\n" && linea != nil && linea != [])
		    			f2.print name + "(" 
				    	str_ary = linea.split(",")
			    		str_ary[0..str_ary.length-2].each do |str|
					    	if str.split(" ").length>1
						    	f2.print "'" + str + "', "
						    else 
					    		f2.print  str + ", "
						    end
					    end
				    	if str_ary[str_ary.length-1][0..-2].split(" ").length>1
			    			f2.puts "'" + str_ary[str_ary.length-1][0..-2] + '\').'
			    		else
						    f2.puts str_ary[str_ary.length-1][0..-2] + ').'
					    end
				    end
			    end
		    end
	    end
    else
        puts "Uso: TraductorCSV_PL.rb fichero.csv Tipo_Columna..."
    end

