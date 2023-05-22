"
model := (MooseModel importFromMSEStream: ('D:\path\to\mseFile.mse' asFileReference readStream)).
model rootFolder: 'D:\pathy\to\rootFolder'.

FAMIX2JavaVisitor new
	rootFolder: 'D:\Developpement\exported' asFileReference;
	export: model.
"
Class {
	#name : #FAMIX2JavaVisitor,
	#superclass : #FAMIXVisitor,
	#instVars : [
		'currentStream',
		'rootFolder',
		'tabs',
		'tabulationSize',
		'endOfLine'
	],
	#category : #Famix2Java
}

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> << aString [
	self indent.
	currentStream << aString
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> <<< aString [
	"without tab"
	currentStream << aString
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> crlf [

	currentStream << String crlf
]

{ #category : #accessing }
FAMIX2JavaVisitor >> currentStream [

	^ currentStream
]

{ #category : #accessing }
FAMIX2JavaVisitor >> currentStream: aStream [

	currentStream := aStream
]

{ #category : #accessing }
FAMIX2JavaVisitor >> endOfLine [

	^ endOfLine
]

{ #category : #accessing }
FAMIX2JavaVisitor >> endOfLine: anObject [

	endOfLine := anObject
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> eol [
	"print the end of line that can be configured"
	self <<< self endOfLine
]

{ #category : #'public-exporting' }
FAMIX2JavaVisitor >> export: aFAMIXCompatibilityModel [
	aFAMIXCompatibilityModel allModelNamespaces
		do: [ :namespace | self clone visit: namespace ]
]

{ #category : #printing }
FAMIX2JavaVisitor >> extractAnnotationTypesFor: aClass [
	| annotationInts |
	annotationInts := OrderedCollection new.
	annotationInts addAll: aClass annotationInstances.
	annotationInts addAll: (aClass methods flatCollect: [ :method | method annotationInstances ]).
	annotationInts addAll: (aClass attributes flatCollect: [ :method | method annotationInstances ]).
	^ annotationInts collect: [ :ann | ann annotationType ] as: Set
]

{ #category : #printing }
FAMIX2JavaVisitor >> extractDeclaredTypesFor: aClass [

	| declaredTypes |
	declaredTypes := ((((aClass queryAllOutgoing collect: #to) flattened
		                    asSet
	                    ,
		                    (((aClass allToScope: FamixTParameter) collect:
			                      #declaredType)
		                     ,
		                     ((aClass allToScope: FamixTStructuralEntity) 
			                      collect: #declaredType)
		                     , (aClass methods collect: #declaredType)
		                     , (aClass methods collect: [ :m | 
				                      m caughtExceptions "collect: #exceptionClass" ])
		                     , (aClass methods collect: [ :m | 
				                      m thrownExceptions "collect: #exceptionClass" ])
		                     , (aClass methods collect: [ :m | 
				                      m declaredExceptions "collect:
					                      #exceptionClass" ]))
			                    flattened) asSet reject: #isNil) flatCollect: [ 
		                  :element | 
		                  element atAnyScope: { 
				                  FamixTClass.
				                  FamixTParameterizedType.
				                  FamixTEnum } ]) asSet.
	(declaredTypes select: [ :dType | 
		 dType isKindOf: FamixJavaParameterizedType ]) do: [ 
		:parameterizedType | 
		declaredTypes addAll: parameterizedType allParametrizedClasses ].
	declaredTypes := declaredTypes reject: [ :dType | 
		                 (dType isKindOf: FamixJavaParameterizedType) or: [ 
			                 ((dType isKindOf: FamixJavaType) and: [ 
				                  dType isAnonymousClass ]) or: [ 
				                 dType name = '?' ] ] ].
	^ declaredTypes
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> indent [
	tabs * tabulationSize timesRepeat: [ currentStream << String space ].
	
]

{ #category : #accessing }
FAMIX2JavaVisitor >> indentMinus [
	tabs := tabs - 1
]

{ #category : #accessing }
FAMIX2JavaVisitor >> indentPlus [
	tabs := tabs + 1
]

{ #category : #initialization }
FAMIX2JavaVisitor >> initialize [

	super initialize.
	self endOfLine: OSPlatform current lineEnding.
	tabs := 0.
	tabulationSize := 4
]

{ #category : #accessing }
FAMIX2JavaVisitor >> printDeclaredType: aDeclaredType [
	aDeclaredType isParameterizedType
		ifFalse: [ currentStream << aDeclaredType name.
			^ self].
	currentStream
		<< aDeclaredType name;
		<< '<'.
	1 to: aDeclaredType arguments size - 1 do: [ :index | 
		self printDeclaredType: (aDeclaredType arguments at: index).
		currentStream << ',' ].
	aDeclaredType arguments
		ifNotEmpty: [ :arguments | self printDeclaredType: arguments last ].
	currentStream << '>'
]

{ #category : #printing }
FAMIX2JavaVisitor >> printExtends: aClass [
	"Print the extension of the class"

	aClass superclass isNil
		ifFalse: [ "ignore Object"
			self
				<<< ' extends ';
				<<< aClass superclass name ]
]

{ #category : #printing }
FAMIX2JavaVisitor >> printImplements: aClass [
	"Prints the implementation of interfaces in a class."

	| interfaces |
	"aClass name = 'AbstractActionBean'
		ifTrue: [ 1 halt ]."
	interfaces := OrderedCollection new.
	interfaces addAll: (aClass superInheritances select: [ :inheritances | inheritances target isInterface ]).
	interfaces isNotEmpty
		ifTrue: [ self
				<<< ' implements ';
				<<< interfaces first target name ].
	2 to: interfaces size do: [ :index | 
		self
			<<< ', ';
			<<< (interfaces at: index) to name ]
]

{ #category : #printing }
FAMIX2JavaVisitor >> printImports: aClass [
	| declaredTypes annotationTypes |
	declaredTypes := self extractDeclaredTypesFor: aClass.
	self printImportsDeclaredTypes: declaredTypes. 
	"fetching annotation imports"
	annotationTypes := self extractAnnotationTypesFor: aClass.
	self printImportsAnnotationTypes: annotationTypes.
	
]

{ #category : #printing }
FAMIX2JavaVisitor >> printImportsAnnotationTypes: annotationTypes [
	(annotationTypes sorted: #mooseName ascending)
		do: [ :annotType | 
			self << 'import '.
			annotType typeContainer fullNamePrintOn: currentStream.
			self
				<<< '.';
				<<< annotType name;
				<<< ';';
				crlf ]
]

{ #category : #printing }
FAMIX2JavaVisitor >> printImportsDeclaredTypes: declaredTypes [
	(declaredTypes sorted: #mooseName ascending)
		do: [ :class | 
			self << 'import '.
			class fullNamePrintOn: currentStream.
			self
				<<< ';';
				eol ]
]

{ #category : #printing }
FAMIX2JavaVisitor >> printMethodAnnotations: aMethod [

	aMethod annotationInstances do: [ :annotationInstance | 
		self clone visit: annotationInstance.
		self eol ]
]

{ #category : #accessing }
FAMIX2JavaVisitor >> reset [
	tabs := 0.
	tabulationSize := 4
]

{ #category : #accessing }
FAMIX2JavaVisitor >> rootFolder [
	^ rootFolder
]

{ #category : #accessing }
FAMIX2JavaVisitor >> rootFolder: anObject [
	rootFolder := anObject
]

{ #category : #'private-exporting' }
FAMIX2JavaVisitor >> space [
	currentStream << String space
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visit: anEntity [
	super visit: anEntity
]

{ #category : #generated }
FAMIX2JavaVisitor >> visitAnnotationInstance: aAnnotationInstance [
	self
		<< '@';
		<<< aAnnotationInstance annotationType name.
	aAnnotationInstance attributes
		ifNotEmpty: [ :attributes | 
			self <<< '('.
			1 to: attributes size - 1 do: [ :index | 
				self clone visit: (attributes at: index).
				self <<< ',' ].
			self clone visit: attributes last.
			self <<< ')' ]
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitAnnotationInstanceAttribute: aAnnotationInstanceAttribute [
	self <<< aAnnotationInstanceAttribute name;
	<<< ' = ';
	<<< aAnnotationInstanceAttribute value
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitAttribute: aAttribute [

	"Visit an attribute to print its annotations and its field."

	" Printing the annotations for the attribute"

	| attributeSource attributeSourceFromName |
	aAttribute annotationInstances do: [ :annotationInstance | 
		self clone visit: annotationInstance.
		self crlf ].

	"Printing modifiers"
	self indent.
	"modifiers := aAttribute cacheAt: #modifiers ifAbsent: [ aAttribute modifiers ].
	modifiers isString
		ifTrue: [ self <<< modifiers ]
		ifFalse: [ modifiers do: [ :modifier | self <<< modifier ] separatedBy: [ self space ] ]."
	"Declared Type"
	aAttribute declaredType
		ifNotNil: [ self printDeclaredType: aAttribute declaredType ]
		ifNil: [ self <<< '/* erreur */ Object' ].
	"Attribute name"
	self
		space;
		<<< aAttribute name.

	"This is an hack to get the affectation is any (hack because some problems with annotations that are sometimes part of the sourceAnchor...)"
	attributeSource := aAttribute sourceAnchor sourceText.
	attributeSource ifNotEmpty: [ 
		attributeSourceFromName := attributeSource copyFrom: (attributeSource findString: aAttribute name) to: attributeSource size.
		(attributeSourceFromName includesSubstring: '=') ifTrue: [ 
			self
				space;
				<<< ((attributeSourceFromName copyFrom: (attributeSourceFromName findString: '=') to: attributeSourceFromName size) removeSuffix: ';') ] ].
	self <<< ';'
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitClass: aClass [
	| file |
	file := self rootFolder / (aClass name , '.java').
	file deleteIfAbsent: [  ].
	file
		writeStreamDo: [ :stream | 
			currentStream := stream.
			"Printing class package and imports if the class is not an inner class"
			aClass container isNamespace
				ifTrue: [ self << 'package '.
					aClass container fullNamePrintOn: currentStream.
					self
						<<< ';';
						crlf;
						crlf.
					self printImports: aClass.
					self crlf ].
			"Printing class annotations"
			aClass annotationInstances
				do: [ :annotationInstance | 
					self clone visit: annotationInstance.
					self crlf ].
			"Printing Class declaration"
			currentStream << 'public '.
			aClass isInterface
				ifTrue: [ currentStream << 'interface ' ]
				ifFalse: [ currentStream << 'class ' ].
			currentStream << aClass name.
			"printing inheritance and implementation"
			self printExtends: aClass.
			self printImplements: aClass.
			currentStream
				<< ' {';
				<< String crlf.
			"Printing Attributs"
			tabs := tabs + 1.
			aClass attributes
				do: [ :attribute | 
					self clone visit: attribute.
					currentStream << String crlf ].
			self crlf.
			"Printing Methods"
			aClass methods
				do: [ :method | 
					self crlf.
					self clone visit: method.
					self crlf ].
			"Closing Class"
			currentStream
				<< String crlf;
				<< '}' ]
]

{ #category : #generated }
FAMIX2JavaVisitor >> visitEntity: aEntity [
	"do nothing if unknow"
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitMethod: aMethod [

	aMethod isStub ifTrue: [ ^ self ].
	"Printing method annotations"
	self printMethodAnnotations: aMethod.
	"Printing modifiers of method ex: static,public/private/protected"
	"aMethod modifiers
		do: [ :modifier | 
			self
				<< modifier;
				space ]."
	self indent.
	aMethod isPrivate ifTrue: [ self <<< 'private ' ].
	aMethod isProtected ifTrue: [ self <<< 'protected ' ].
	aMethod isPublic ifTrue: [ self <<< 'public ' ].
	aMethod isClassSide ifTrue: [ self <<< 'static ' ].
	"Printing return type for method"
	aMethod declaredType ifNotNil: [ :declaredType | 
		self printDeclaredType: declaredType.
		currentStream << String space ].
	"Printing name + parameters of method"
	(aMethod name = '<Initializer>' or: [ 
		 aMethod isAnInitializer and: [ aMethod isConstructor not ] ])
		ifFalse: [ 
			self
				<<< aMethod name;
				<<< '('.
			(aMethod parameters sorted: [ :p :p2 | 
				 p sourceAnchor startPos < p2 sourceAnchor startPos ])
				do: [ :parameter | self clone visit: parameter ]
				separatedBy: [ self <<< ', ' ].
			self <<< ')' ]
		ifTrue: [ self << 'static' ].
	"print exception"
	((aMethod withMethodsOverriding collect: [ :m | 
		  m thrownExceptions , m declaredExceptions ])
		 flattened asSet asOrderedCollection sorted: #name ascending) 
		ifNotEmpty: [ :exceptions | 
			self <<< ' throws '.
			exceptions
				do: [ :exception | self <<< exception name ]
				separatedBy: [ self <<< ', ' ] ].

	"Printing body of method if class is not abstract or an interface"
	((aMethod atScope: FamixTClass) anyOne isInterface or: [ 
		 aMethod isAbstract isNotNil and: [ aMethod isAbstract ] ])
		ifTrue: [ self <<< ';' ]
		ifFalse: [ 
			currentStream << ' {'.
			self eol.
			self << aMethod bodySourceText.
			self
				eol;
				<< '}' ]
]

{ #category : #accessing }
FAMIX2JavaVisitor >> visitNamespace: aNamespace [
	"create the folder for this namespace"

	aNamespace name = '<Default Package>'
		ifFalse: [ aNamespace allParents reverse
				do: [ :namespace | 
					self rootFolder: self rootFolder / namespace name.
					self rootFolder ensureCreateDirectory ].
			self rootFolder: self rootFolder / aNamespace name.
			self rootFolder ensureCreateDirectory ].
	aNamespace children do: [ :child | self clone visit: child ]
]

{ #category : #generated }
FAMIX2JavaVisitor >> visitParameter: aParameter [
	aParameter declaredType isParameterizedType
		ifTrue: [ self visitParameterizableType: aParameter declaredType ]
		ifFalse: [ self <<< aParameter declaredType name ].
	self
		space;
		<<< aParameter name
]

{ #category : #generated }
FAMIX2JavaVisitor >> visitParameterizableType: aParameterizableType [
	self <<< aParameterizableType name.
	self <<< '<'.
	aParameterizableType arguments
		do: [ :argument | 
			argument isParameterType
				ifTrue: [ self visitParameterizableType: argument ]
				ifFalse: [ self <<< argument name ] ]
		separatedBy: [ self <<< ',' ].
	self <<< '>'
]

{ #category : #generated }
FAMIX2JavaVisitor >> visitParameterizedType: aParameterizedType [

	self <<< aParameterizedType name.
	aParameterizedType arguments ifNotEmpty: [ :arguments | 
		self <<< '<'.
		arguments
			do: [ :argument | 
				argument isParameterType
					ifTrue: [ self visitParameterizableType: argument ]
					ifFalse: [ self <<< argument name ] ]
			separatedBy: [ self <<< ',' ].
		self <<< '>' ]
]
