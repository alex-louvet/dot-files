function dp --argument folder
rm $folder/values.csv;
for f in $folder/*.json
python3 dp_computation.py $f 0.1 >> $folder/values.csv;
end
python3 visualization/histo_eps.py $folder/values.csv $folder/histo_eps.png;python3 visualization/histo_pop.py $folder/values.csv $folder/histo_pop.png;python3 visualization/scatter_eps_k.py $folder/values.csv $folder/scatter_k.png;python3 visualization/scatter_eps_pop.py $folder/values.csv $folder/scatter_pop.png;
end
