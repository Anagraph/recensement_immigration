#!/bin/bash
IFS=',';

while read -r a b c ; do

		echo Le pays en cours est : $b

		echo 'delete first line of each csv'

			#sed -i '1,1d' *.csv

			#cat QC.csv ON.csv CB.csv PR.csv TR.csv ATL.csv > IMMCANADA.csv


		echo '#1 Fill the empty values (if not COPY to PostgreSQL returns error)'
		# INPUT  VALUE
		# ./fill-empty-values.sh IMM_TNL.csv 0
		#!/bin/bash

				#for i in $( seq 1 2); do
				 # sed  "s/^,/$2,/" -e "s/,,/,$2,/g" -e "s/,$/,$2/" -i $1

				#done
						#bash fill-empty-values.sh myfile.csv 0

				# extraire seulement les données ou la colonne 3 (niveau_geo = 4 (DA))

					# imprimer seulement les DA
			#awk -F"," '$3 ~ /4/ {print $0}' IMMCANADA_LF.csv >> IMMCANADA_DA.csv
					# imprimer seulement le CAnada niveau geo 0
			#awk -F"," '$3 ~ /0/ {print $0}' IMMCANADA.csv >> IMMCANADA_F.csv

		echo '#2 - Parser les données pour chaque pays du top ou chacune des 18 régions'
			#awk 'NR%1678==1212' IMMCANADA.csv > NON_IMM_TEMP.csv
			time sed -n ""$a"~1678p" IMMCANADA.csv > NON_IMM_TEMP.csv
			sed -e 's#,,"09999",#,0,0,"09999",#g'  NON_IMM_TEMP.csv > FIXED_TEMP.csv
			sed -e 's#,"00999",#,0,"00999",0#g' FIXED_TEMP.csv > FIXED_TEMP2.csv
			sed -e 's#,"05999",#,0,"05999",0#g' FIXED_TEMP2.csv > FIXED_TEMP3.csv
			sed -e 's#,"04999",#,0,"04999",0#g' FIXED_TEMP3.csv > FIXED_TEMP4.csv
			sed -e 's#,,"19999",#,0,0,"19999",#g'  FIXED_TEMP4.csv > FIXED_TEMP5.csv
			sed -e 's#,"01999",#,0,"01999",0#g' FIXED_TEMP5.csv > FIXED_TEMP6.csv
			sed -e 's#,"03999",#,0,"03999",0#g' FIXED_TEMP6.csv > FIXED_TEMP7.csv
			sed -e 's#,"02999",#,0,"02999",0#g' FIXED_TEMP7.csv > FIXED_TEMP8.csv
			#cut -d, -f1,3,4,5,6,7,8,9,11 --complement temp.csv

			sed 1i"annee,geo_code,niveaugeo,nomgeo,tgn,tgnfl,indicateur,empty,code_geo_alt,caracterstique,dim,memberid,total,sexm,sexf"  FIXED_TEMP8.csv > $c"_"$a.csv

		#supprimer les colonnes en trop



		#remove windows linebreaks replace by unix linebreaks
			#sed -r 's/\r$//' IMM_CAN.csv > IMM_CAN_LF.csv
		#re-encode to UTF8

			#iconv -f "windows-1252" -t "UTF-8" IMM_CAN_LF.csv -o IMM_CAN_LF_UTF.csv


		#remove temp files
			sudo rm NON_IMM_TEMP.csv
			sudo rm FIXED_TEMP.csv
			sudo rm FIXED_TEMP2.csv
			sudo rm FIXED_TEMP3.csv
			sudo rm FIXED_TEMP4.csv
			sudo rm FIXED_TEMP5.csv
			sudo rm FIXED_TEMP6.csv
			sudo rm FIXED_TEMP7.csv
			sudo rm FIXED_TEMP8.csv

		echo '#5 - Créer une table pour chaque pays du top ou chacune des 18 régions'

			psql -d warehouse -c "CREATE TABLE "$c"_"$a" (annee varchar,geo_code varchar,niveaugeo varchar,nomgeo varchar,tgn varchar,tgnfl varchar,indicateur varchar,empty varchar,code_geo_alt varchar, caracterstique varchar,dim varchar,memberid varchar,total varchar,sexm varchar,sexf varchar);"

		echo '#6 - Importer les données de chaque pays dans les tables correspondantes'

		psql -d warehouse -c "\COPY "$c"_"$a" FROM '"$c"_"$a".csv' DELIMITER ',' CSV HEADER;"

		echo '#7 - Nettoyer la table ( il y a des x F .. et ... dans la colonne totale)'

			psql -d warehouse -c " UPDATE "$c"_"$a" SET total = REPLACE(total, N'x', N'0');"
			psql -d warehouse -c " UPDATE "$c"_"$a" SET total = REPLACE(total, N'F', N'0');"
			psql -d warehouse -c " UPDATE "$c"_"$a" SET total = REPLACE(total, N'..', N'0');"
			psql -d warehouse -c " UPDATE "$c"_"$a" SET total = REPLACE(total, N'...', N'0');"
			psql -d warehouse -c "ALTER TABLE "$c"_"$a" ALTER COLUMN total TYPE numeric USING total::numeric;"

		echo '#8 - Joindre le data dans les géographies'

			psql -d warehouse -c " SELECT * into "$c"_"$a"_DA FROM lad_clip_ecou lad LEFT JOIN "$c"_"$a" immCanMaster on lad.adidu = immCanMaster.geo_code;"

		echo '#9 - Générer le fichier de points pour chaque pays du top ou chacune des 18 régions'

			psql -d warehouse -c "CREATE TABLE "$c"_"$a"_DA_pts AS SELECT * FROM (SELECT (ST_DUMP(ST_GeneratePoints(geom, total))).geom FROM "$c"_"$a"_DA) da;"

		echo '#9.1 Remplir le champs nation avec le nom de la dite nation'

				psql -d warehouse -c "ALTER TABLE "$c"_"$a"_DA_pts ADD COLUMN pays varchar DEFAULT '"$b"' ;"

		echo '#9.2 Remplir le champs region avec le nom de la dite régions'

				psql -d warehouse -c "ALTER TABLE "$c"_"$a"_DA_pts ADD COLUMN region varchar DEFAULT '"$c"' ;"



		done < inputs.csv
time

		echo '#10 - Merger tous les fichiers de points en 1 seul'
			#Create table immigration_3857(pays varchar, region varchar);
			
			psql -d warehouse -c "CREATE TABLE immigration_3857(pays varchar, region varchar);
			SELECT AddGeometryColumn('immigration_3857','geom',0,'point',2);
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_autre_1193_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Est_1190_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Ouest_1187_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Ouest_1188_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Ouest_1191_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Nord_1185_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Nord_1186_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Nord_1189_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Afrique_Sud_1192_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_autre_1165_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_centrale_1157_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_centrale_1161_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_Nord_1164_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_Sud_1155_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_Sud_1156_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_Sud_1158_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Amerique_Sud_1162_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Antilles_Bermudes_1159_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Antilles_Bermudes_1160_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Antilles_Bermudes_1163_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_autre_1211_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Est_1197_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Est_1198_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Est_1202_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Est_1203_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Est_1209_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Ouest_centrale_Moyen_Orient_1195_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Ouest_centrale_Moyen_Orient_1200_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Ouest_centrale_Moyen_Orient_1201_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Ouest_centrale_Moyen_Orient_1204_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Ouest_centrale_Moyen_Orient_1208_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Sud_1196_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Sud_1199_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Sud_1205_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Sud_1207_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Sud_Est_1206_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Asie_Sud_Est_1210_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Oceanie_et_autres_1212_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_autre_1183_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Est_1172_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Est_1176_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Est_1178_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Est_1179_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Est_1181_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Ouest_1169_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Ouest_1170_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Ouest_1175_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Nord_1173_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Nord_1182_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Sud_1167_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Sud_1168_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Sud_1171_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Sud_1174_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Sud_1177_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Europe_Sud_1180_da_pts;
			INSERT INTO immigration_3857 (pays, region, geom) SELECT pays, region,geom FROM Canada_1137_da_pts;
			select UpdateGeometrySRID('immigration_3857', 'geom', 3857);"

			#select UpdateGeometrySRID('immigration_3857', 'geom', 3857);
			

						

		echo '#11 - Exporter la table immigration en geoJSON'

			#ogr2ogr -f "GeoJSON" -t_srs EPSG:3857 immigration_3857v2.geojson PG:"dbname=warehouse host=localhost user=clement password=bidon" -sql "SELECT * FROM immigration_3857;"


		echo '#12 - Générer le fichier mbtiles avec Tippecanoe, paramètré par Nicolas 30/10/2017'

		#tippecanoe -s EPSG:3857 -f -o immigration_nico.mbtiles immigration_3857.geojson -pD -r1 --drop-fraction-as-needed

		echo 'Fin du process pour variable'
