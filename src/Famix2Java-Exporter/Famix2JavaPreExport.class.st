Class {
	#name : #Famix2JavaPreExport,
	#superclass : #Object,
	#instVars : [
		'model',
		'realPaths',
		'projectNames',
		'projectPaths',
		'mainProjetName',
		'srcPath',
		'originProjetPath'
	],
	#category : #'Famix2Java-Exporter'
}

{ #category : #'as yet unclassified' }
Famix2JavaPreExport >> allOriginalJavaFiles [ 
	^ originProjetPath allChildrenMatching: '*.java'.
]

{ #category : #initialization }
Famix2JavaPreExport >> initialize [ 
	model := MooseModel root first.
	mainProjetName := 'legacy-ecompta'.
	srcPath := 'src/main/java'.
	originProjetPath := '/Users/nicolashlad/Development/artefact-Avenir/latest-sources/legacy-ecompta' asFileReference . 
	
]

{ #category : #accessing }
Famix2JavaPreExport >> projectNames [
	
	projectNames := Set new.
	realPaths do: [ :path |
		projectNames add: path pathSegments second. 		
		 ].
	^ projectNames .
]

{ #category : #accessing }
Famix2JavaPreExport >> projectPaths [

	|res|
	res := OrderedCollection new. 
	
	res add: (#client -> ('/' join: { mainProjetName . #client . #'src/main/java' })).
	res add: (#conception -> ('/' join: { mainProjetName . #conception . #'src/main/resources' })).
	res add: (#dataupdate -> ('/' join: { mainProjetName . #dataupdate . #'src/main/java' })).	
	res add: (#reftechnique -> ('/' join: { mainProjetName . #reftechnique . #'src' })).		
	res add: (#serveur -> ('/' join: { mainProjetName . #serveur . #'src/main/java' })).			
	res add: (#transverse -> ('/' join: { mainProjetName . #transverse . #'src/main/java' })).				

	^res

"	
	^ projectNames collect: [ :pName |
		pName -> ('/' join: { mainProjetName . pName . srcPath }).
		 ]."
]

{ #category : #'as yet unclassified' }
Famix2JavaPreExport >> resolveAllRealPath [
"	| classesPath classes interfaces|"

	"explore all the concret classes of a  model to output their path. Anonymous class are ignored"
	self flag: [ 'il manque les interfces et les exceptions à minima (or allModelclasses)' ].

	realPaths := Set new.
		model allModelEntities do: [:e | 
			(( e isKindOf: FamixJavaSourceAnchor) 
				and: [ e fileName isNotNil ]) 
				ifTrue: [realPaths add: (e fileName asFileReference) ] ].
	^ realPaths .
	
	"
	interfaces := model allModelEntities select: [ :e | e isKindOf: FamixJavaInterface ].
	1 halt.
	
	classes := model allModelClasses.
	classesPath := Set new.
	
	realPaths :=  classesPath addAll: ((((classes reject: [:c | c isAnonymousClass or: [ c isInnerClass ]  ])) 
														reject: [ :c | c sourceAnchor isNil ]) collect: [ :c | 
			           c sourceAnchor fileName asFileReference  ]); yourself.
	^ realPaths "
	
]

{ #category : #'as yet unclassified' }
Famix2JavaPreExport >> resolvePackagepaths [
	|packages  prjt2Pckgs  |
	
	prjt2Pckgs := Dictionary new.
	projectNames do: [ :pname |
		prjt2Pckgs add: (pname -> Set new)
		 ].
	
	packages := model allModelPackages.
	packages do: [ :package | "faire un dictionnaire des vrais path. partir des classes de chaque package et de leur anchor file""ajouter"
		  | paths pckName pckPath aClass aClassPath |
		  pckPath := OrderedCollection new.
		  pckName := package name.
		  "retreive the path of all concret class in this package with a file "
		" "
		
			"aClass := ((((package allToScope: FamixJavaClass) reject:
			            #isAnonymousClass)) reject: [ :c | c sourceAnchor isNil ]) ifEmpty: [ nil ] ifNotEmpty: [ :v | v anyOne ]."
		
			aClass := ((package allToScope: FamixJavaSourcedEntity  ) reject: [ :c | c sourceAnchor isNil ])  ifEmpty: [ nil ] ifNotEmpty: [ :v | v anyOne ].
			
			aClass ifNotNil: [ 
				aClassPath := aClass sourceAnchor fileName asFileReference.
			prjt2Pckgs at: ( aClassPath pathSegments second ) ifPresent: [ :v | v add: package ].
					 "self haltIf: ((aClassPath pathSegments nextToLast) = ( aClassPath pathSegments second )) ".  ] .
			
				   
		 
		 ].

	^ prjt2Pckgs
]

{ #category : #search }
Famix2JavaPreExport >> searchAPackageNamed: aString [ 
	|dic res|
	dic := self resolvePackagepaths .
	res := OrderedCollection new.
	dic valuesDo: [ :set |
		res addAll: (set select: [ :pkg |
			pkg name = aString.
			 ]).
		 ].
	^ res. 
]
