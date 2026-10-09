VNM.class: VNM.jjt
	rm -f AST/*
	cp SimpleNode.java AST
	jjtree VNM.jjt
	javacc AST/VNM.jj
	javac -classpath .:./AST  AST/*.java
	javac -classpath .:./AST  *.java
