"
Allows the Famix2JavaVisitor to filter a set out the methods that are not into a set of selected FamixJavaMethod

	visitor := FAMIX2JavaFiltered new.
	visitor selectedMethods: {aFamixJavaMethod}. 
	visitor endOfLine: String cr.
	visitor exportFolder: 'exportPath/' asFileReference.
	visitor rootFolder: 'exportPath/' asFileReference.
	
	visitor export: MooseModel root at: 1.
"
Class {
	#name : #FAMIX2JavaFiltered,
	#superclass : #FAMIX2JavaVisitor,
	#instVars : [
		'selectedMethods'
	],
	#category : #Famix2Java
}

{ #category : #accessing }
FAMIX2JavaFiltered >> selectedMethods: anObject [

	selectedMethods := anObject
]

{ #category : #visiting }
FAMIX2JavaFiltered >> visitMethod: aMethod [
	
	(selectedMethods includes: aMethod) ifTrue: [ 
		super visitMethod: aMethod ].
	
]
