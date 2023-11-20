Class {
	#name : #Famix2JavaExporter,
	#superclass : #Object,
	#instVars : [
		'preExporter',
		'destPath',
		'visitor'
	],
	#category : #'Famix2Java-Exporter'
}

{ #category : #setter }
Famix2JavaExporter >> destination: aString [ 
	destPath := aString.
]

{ #category : #public }
Famix2JavaExporter >> export [
	
	
	visitor := FAMIX2JavaVisitor new.
	visitor endOfLine: String cr.
	
"	1 halt.
	preExporter searchAPackageNamed: 'bureau'.
	visitor visitPackage: (preExporter searchAPackageNamed: 'bureau') anyOne."
	
	
	
	preExporter projectPaths do: [ :prjt |
		|name prjtPath dic|
		name := prjt key. 
		prjtPath := prjt value. 
		
		
		visitor exportFolder: destPath asFileReference / prjtPath .
		visitor rootFolder: destPath asFileReference / prjtPath .
		
		dic := preExporter resolvePackagepaths .
		
		(dic at: name) do: [ :pkg |
			
			visitor visitPackage: pkg. 
			 ].	
		 ].
	
]

{ #category : #setter }
Famix2JavaExporter >> preExporter: aFamix2JavaPreExport [ 
	preExporter := aFamix2JavaPreExport
]
