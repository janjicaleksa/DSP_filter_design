function f = pikovi(X,Fs,N)

[all_peaks, all_locations] = findpeaks(X,'MinPeakDistance',200);
peaks = [];
locations = [];
for i=1:length(all_peaks)
    if (all_peaks(i) > 0.03*(max(all_peaks))) %kriterijum biranja pikova
        peaks = [peaks all_peaks(i)]; %vrednosti amplituda
        locations = [locations all_locations(i)]; %vrednosti pozicija u nizu
    end
end

locations = locations*(Fs/N); % skaliranje pozicija pikova u Hz

%u vektoru locations se nalaze neke vrednosti u Hz koje su jako bliske
%jedna drugoj, stoga je potrebno te bliske vrednosti usrednjiti i 
%sacuvati u nekom novom vektoru valid_locations

pom = [];
valid_locations = [];
for i=1:length(locations)
    if (i == 1)
        pom = [locations(i)];
    else
        if (locations(i) - locations(i-1) > 100)
            valid_locations = [valid_locations sum(pom)/length(pom)];
            pom = [locations(i)];
        else
            pom = [pom locations(i)];
        end
    end
end
valid_locations = [valid_locations sum(pom)/length(pom)];

distances = diff(valid_locations); %rastojanja izmedju susednih pikova
average_distance = sum(distances)/length(distances); %uprosecena rastojanja
number_peaks = length(valid_locations);
for i=1:number_peaks
    if(locations(i) > 20) %treba nam prvi pik, a ne DC komponenta
        first_pick = locations(i);
        break
    end
end
f = [first_pick average_distance];
end