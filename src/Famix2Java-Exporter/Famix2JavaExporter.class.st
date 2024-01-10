Class {
	#name : #Famix2JavaExporter,
	#superclass : #Object,
	#instVars : [
		'destinationPath',
		'visitor',
		'model'
	],
	#category : #'Famix2Java-Exporter'
}

{ #category : #accessing }
Famix2JavaExporter >> destinationPath [

	^ destinationPath
]

{ #category : #accessing }
Famix2JavaExporter >> destinationPath: anObject [

	destinationPath := anObject
]

{ #category : #initialization }
Famix2JavaExporter >> initialize [ 

	visitor := FAMIX2JavaVisitor new.
	visitor endOfLine: String cr.
	visitor exportFolder: destinationPath asFileReference.
	visitor rootFolder: destinationPath asFileReference .
	
	model := MooseModel root at: 1. 
	
	visitor export: model.
		
	
	
	
]

{ #category : #accessing }
Famix2JavaExporter >> visitor [

	^ visitor
]
