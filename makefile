

	
all: pattern pattern2 pattern3 pattern4 pattern5 pattern6 pattern7 pattern8 pattern9
      
pattern : pattern.cpp
	g++ -O3 pattern.cpp -o pattern -ltiff

pattern2 : pattern2.cpp
	g++ -O3 pattern2.cpp -o pattern2  -ltiff


pattern3 : pattern3.cpp
	g++ -O3 pattern3.cpp -o pattern3  -ltiff

pattern4 : pattern4.cpp
	g++ -O3 pattern4.cpp -o pattern4  -ltiff

pattern5 : pattern5.cpp
	g++ -O3 pattern5.cpp -o pattern5  -ltiff
			
pattern6 : pattern6.cpp
	g++ -O3 pattern6.cpp -o pattern6  -ltiff
	
pattern7 : pattern7.cpp
	g++ -O3 pattern7.cpp -o pattern7  -ltiff
	
pattern8 : pattern8.cpp
	g++ -O3 pattern8.cpp -o pattern8  -ltiff

pattern9 : pattern9.cpp
	g++ -O3 pattern9.cpp -o pattern9  -ltiff
	
clean : 
	rm -v pattern pattern2 pattern3 pattern4 pattern5 pattern6 pattern7 pattern8 pattern9
  
