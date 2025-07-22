"
model := (MooseModel importFromMSEStream: ('D:\path\to\mseFile.mse' asFileReference readStream)).
model rootFolder: 'D:\pathy\to\rootFolder'.

FAMIX2JavaVisitor new
	rootFolder: 'D:\Developpement\exported' asFileReference;
	export: model.
"
Class {
	#name : 'FAMIX2JavaVisitor',
	#superclass : 'Object',
	#traits : 'FamixJavaTVisitor',
	#classTraits : 'FamixJavaTVisitor classTrait',
	#instVars : [
		'currentStream',
		'rootFolder',
		'tabs',
		'tabulationSize',
		'endOfLine'
	],
	#category : 'Famix2Java',
	#package : 'Famix2Java'
}

{ #category : 'private-exporting' }
FAMIX2JavaVisitor >> << aString [

	currentStream << aString
]

{ #category : 'private-exporting' }
FAMIX2JavaVisitor >> <<| aString [

	self indent.
	self << aString
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> currentStream [

	^ currentStream
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> currentStream: aStream [

	currentStream := aStream
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> endOfLine [

	^ endOfLine
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> endOfLine: anObject [

	endOfLine := anObject
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> ensureCreateDirectoryForPackage: aFamixJavaPackage [

	| folder |
	folder := self rootFolder.
	aFamixJavaPackage name = '<Default Package>' ifTrue: [ ^ self ].
	aFamixJavaPackage allParents reverse do: [ :namespace |
		folder := folder / namespace name.
		folder ensureCreateDirectory ].
	folder := folder / aFamixJavaPackage name.
	^ folder ensureCreateDirectory
]

{ #category : 'private-exporting' }
FAMIX2JavaVisitor >> eol [
	"print the end of line that can be configured"
	self << self endOfLine
]

{ #category : 'public-exporting' }
FAMIX2JavaVisitor >> export: aFAMIXCompatibilityModel [
	aFAMIXCompatibilityModel allModelPackages
		do: [ :package | package accept: self clone ]
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> extractAnnotationTypesFor: aClass [
	| annotationInts |
	annotationInts := OrderedCollection new.
	annotationInts addAll: aClass annotationInstances.
	annotationInts addAll: (aClass methods flatCollect: [ :method | method annotationInstances ]).
	annotationInts addAll: (aClass attributes flatCollect: [ :method | method annotationInstances ]).
	^ annotationInts collect: [ :ann | ann annotationType ] as: Set
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> extractDeclaredTypesFor: aClass [

	| declaredTypes |
	declaredTypes := ((((aClass queryAllOutgoing collect: #target)
		                    flattened asSet
	                    ,
		                    (((aClass allToScope: FamixTParameter) collect:
			                      #declaredType)
		                     ,
		                     ((aClass allToScope: FamixTStructuralEntity)
			                      collect: #declaredType)
		                     , (aClass methods collect: #declaredType)
		                     ,
		                     (aClass methods collect: [ :m |
			                      m caughtExceptions ])
		                     ,
		                     (aClass methods collect: [ :m |
			                      m thrownExceptions ])
		                     ,
		                     (aClass methods collect: [ :m |
			                      m declaredExceptions ])) flattened) asSet
		                   reject: #isNil) flatCollect: [ :element |
		                  element atAnyScope: {
				                  FamixTClass.
				                  FamixTImplementable.
				                  FamixTEnum } ]) asSet.
	(declaredTypes select: [ :dType | dType isParametricEntity ]) do: [
		:parameterizedType |
		declaredTypes addAll: parameterizedType concreteParameters ].
	declaredTypes := declaredTypes reject: [ :dType |
		                 (dType isParametricEntity and: [
			                  dType isGenericEntity ]) or: [
			                 ((dType isKindOf: FamixJavaType) and: [
				                  dType isAnonymousClass ]) or: [
				                 dType name = '?' ] ] ].
	^ declaredTypes
]

{ #category : 'private-exporting' }
FAMIX2JavaVisitor >> indent [
	tabs * tabulationSize timesRepeat: [ currentStream << String space ].
	
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> indentMinus [
	tabs := tabs - 1
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> indentPlus [
	tabs := tabs + 1
]

{ #category : 'initialization' }
FAMIX2JavaVisitor >> initialize [

	super initialize.
	self endOfLine: OSPlatform current lineEnding.
	self reset
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> printContentOfClass: aClass [

	aClass types ifNotEmpty: [ :innerTypes |
		self eol.
		innerTypes do: [ :innerType |
			innerType accept: self.
			self eol ] ].

	aClass attributes ifNotEmpty: [ :attributes |
		self eol.
		attributes do: [ :attribute |
			attribute accept: self.
			self eol ] ].
	"Printing Methods"
	aClass methods ifNotEmpty: [ :methods |
		methods do: [ :method |
			self eol.
			method accept: self.
			self eol ] ]
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> printDeclaredType: aDeclaredType [
	aDeclaredType isParametricEntity ifFalse: [
		currentStream << aDeclaredType name.
		^ self ].
	currentStream
		<< aDeclaredType name;
		<< '<'.
	aDeclaredType concreteParameters
		do: [ :parameter | self printDeclaredType: parameter ]
		separatedBy: [ currentStream << ', ' ].
	currentStream << '>'
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> printExtends: aClass [
	"Print the extension of the class"

	aClass superclass isNil
		ifFalse: [ "ignore Object"
			self
				<< ' extends ';
				<< aClass superclass name ]
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> printImplements: aClass [
	"Prints the implementation of interfaces in a class."

	| interfaces |

	interfaces := aClass interfaceImplementations.
	interfaces ifNotEmpty: [ :implementations |
		self << ' implements '.
		implementations
			do: [ :implementation | self << implementation interface name ]
			separatedBy: [ self << ', ' ] ]
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> printImports: aClass [
	| declaredTypes annotationTypes |
	declaredTypes := self extractDeclaredTypesFor: aClass.
	self printImportsDeclaredTypes: declaredTypes. 
	"fetching annotation imports"
	annotationTypes := self extractAnnotationTypesFor: aClass.
	self printImportsAnnotationTypes: annotationTypes
	
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> printImportsAnnotationTypes: annotationTypes [
	(annotationTypes sorted: #mooseName ascending)
		do: [ :annotType | 
			self << 'import '.
			annotType typeContainer fullNamePrintOn: currentStream.
			self
				<< '.';
				<< annotType name;
				<< ';';
				eol ]
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> printImportsDeclaredTypes: declaredTypes [
	(declaredTypes sorted: #mooseName ascending)
		do: [ :class | 
			self <<| 'import '.
			class fullNamePrintOn: currentStream.
			self
				<< ';';
				eol ]
]

{ #category : 'printing' }
FAMIX2JavaVisitor >> printMethodAnnotations: aMethod [

	aMethod annotationInstances do: [ :annotationInstance | 
		annotationInstance accept: self clone.
		self eol ]
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> printStatementBlockOf: aMethod [

	self << ' {'.
	self eol.
	self << aMethod bodySourceText.
	self
		eol;
		<<| '}'
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> reset [
	tabs := 0.
	tabulationSize := 4
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> rootFolder [
	^ rootFolder
]

{ #category : 'accessing' }
FAMIX2JavaVisitor >> rootFolder: anObject [
	rootFolder := anObject
]

{ #category : 'private-exporting' }
FAMIX2JavaVisitor >> space [
	currentStream << String space
]

{ #category : 'generated' }
FAMIX2JavaVisitor >> visitEntity: aEntity [
	"do nothing if unknow"
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaAnnotationInstance: aFamixJavaAnnotationInstance [

	self
		<<| '@';
		<< aFamixJavaAnnotationInstance annotationType name.
	aFamixJavaAnnotationInstance attributes ifNotEmpty: [ :attributes |
		self << '('.
		attributes
			do: [ :attribute | attribute accept: self ]
			separatedBy: [ self << ',' ].
		self << ')' ]
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaAnnotationInstanceAttribute: aFamixJavaAnnotationInstanceAttribute [

	self
		<< aFamixJavaAnnotationInstanceAttribute name;
		<< ' = ';
		<< aFamixJavaAnnotationInstanceAttribute value
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaAttribute: aFamixJavaAttribute [
	"Visit an attribute to print its annotations and its field."

	" Printing the annotations for the attribute"

	| attributeSource attributeSourceFromName |
	aFamixJavaAttribute annotationInstances do: [ :annotationInstance |
		annotationInstance accept: self.
		self eol ].

	"Printing modifiers"
	self indent.
	aFamixJavaAttribute isPrivate ifTrue: [ self << 'private ' ].
	aFamixJavaAttribute isProtected ifTrue: [ self << 'protected ' ].
	aFamixJavaAttribute isPublic ifTrue: [ self << 'public ' ].
	aFamixJavaAttribute isClassSide ifTrue: [ self << 'static ' ].
	aFamixJavaAttribute isFinal ifTrue: [ self << 'final ' ].
	aFamixJavaAttribute isTransient ifTrue: [ self << 'transient ' ].
	"Declared Type"
	aFamixJavaAttribute declaredType
		ifNotNil: [
		self printDeclaredType: aFamixJavaAttribute declaredType ]
		ifNil: [ self << '/* erreur */ Object' ].
	"Attribute name"
	self
		space;
		<< aFamixJavaAttribute name.

	"This is an hack to get the affectation is any (hack because some problems with annotations that are sometimes part of the sourceAnchor...)"
	attributeSource := aFamixJavaAttribute sourceAnchor
		                   ifNil: [ '' ]
		                   ifNotNil: [ :sourceAnchor |
		                   sourceAnchor sourceText ].
	attributeSource ifNotEmpty: [
		attributeSourceFromName := attributeSource
			                           copyFrom:
			                           (attributeSource findString:
				                            aFamixJavaAttribute name)
			                           to: attributeSource size.
		(attributeSourceFromName includesSubstring: '=') ifTrue: [
			self
				space;
				<< ((attributeSourceFromName
						  copyFrom: (attributeSourceFromName findString: '=')
						  to: attributeSourceFromName size) removeSuffix: ';') ] ].
	self << ';'
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaClass: aClass [
	"Printing class package and imports if the class is not an inner class"

	"Printing class annotations""Printing Class declaration""printing inheritance and implementation""Printing Attributs""Printing Methods""Closing Class"

	(aClass typeContainer isKindOf: FamixJavaPackage) ifTrue: [
		self << 'package '.
		aClass typeContainer fullNamePrintOn: currentStream.
		self
			<< ';';
			eol;
			eol.
		self printImports: aClass.
		self eol ].
	aClass annotationInstances do: [ :annotationInstance |
		annotationInstance accept: self clone.
		self eol ].
	self <<| 'public class '.
	self << aClass name.
	self printExtends: aClass.
	self printImplements: aClass.
	self << ' {'.
	self eol.
	self indentPlus.
	self printContentOfClass: aClass.
	self eol.
	self indentMinus.
	self <<| '}'
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaInterface: aFamixJavaInterface [
	"Printing class package and imports if the class is not an inner class"

	(aFamixJavaInterface typeContainer isNotNil and: [
		 aFamixJavaInterface typeContainer isKindOf: FamixJavaPackage ])
		ifTrue: [
			self << 'package '.
			aFamixJavaInterface typeContainer fullNamePrintOn: currentStream.
			self
				<< ';';
				eol;
				eol.
			self printImports: aFamixJavaInterface.
			self eol ].
	"Printing class annotations"
	aFamixJavaInterface annotationInstances do: [ :annotationInstance |
		self clone visit: annotationInstance.
		self eol ].
	"Printing Class declaration"
	currentStream << 'public interface '.
	currentStream << aFamixJavaInterface name.
	"printing inheritance and implementation"
	self printExtends: aFamixJavaInterface.
	self << ' {'.
	self eol.
	self indentPlus.
	self printContentOfClass: aFamixJavaInterface.
	self eol.
	self indentMinus.
	self <<| '}'
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaMethod: aMethod [

	| parameters |
	aMethod isStub ifTrue: [ ^ self ].
	"Printing method annotations"
	self printMethodAnnotations: aMethod.
	"Printing modifiers of method ex: static,public/private/protected"
	self indent.
	aMethod isPrivate ifTrue: [ self << 'private ' ].
	aMethod isProtected ifTrue: [ self << 'protected ' ].
	aMethod isPublic ifTrue: [ self << 'public ' ].
	aMethod isClassSide ifTrue: [ self << 'static ' ].
	"Printing return type for method"
	aMethod declaredType ifNotNil: [ :declaredType |
		self printDeclaredType: declaredType.
		currentStream << String space ].
	"Printing name + parameters of method"
	(aMethod name = '<Initializer>' or: [
		 aMethod isAnInitializer and: [ aMethod isConstructor not ] ])
		ifFalse: [
			self
				<< aMethod name;
				<< '('.
			parameters := aMethod parameters.
			(parameters allSatisfy: [ :p | p hasSourceAnchor ]) ifTrue: [
				parameters := parameters sorted: [ :p :p2 |
					              p sourceAnchor startPos < p2 sourceAnchor startPos ] ].
			parameters
				do: [ :parameter | parameter accept: self ]
				separatedBy: [ self << ', ' ].
			self << ')' ]
		ifTrue: [ self << 'static' ].
	"print exception"
	((aMethod withMethodsOverriding collect: [ :m |
		  m thrownExceptions , m declaredExceptions ]) flattened asSet
		 asOrderedCollection sorted: #name ascending) ifNotEmpty: [
		:exceptions |
		self << ' throws '.
		exceptions
			do: [ :exception | self << exception name ]
			separatedBy: [ self << ', ' ] ].

	"Printing body of method if class is not abstract or an interface"
	(aMethod parentType isInterface or: [
		 aMethod isAbstract isNotNil and: [ aMethod isAbstract ] ])
		ifTrue: [ self << ';' ]
		ifFalse: [ self printStatementBlockOf: aMethod ]
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaPackage: aFamixJavaPackage [

	aFamixJavaPackage types do: [ :type |
		| file folder |
		folder := self ensureCreateDirectoryForPackage: aFamixJavaPackage.

		file := folder / (type name , '.java').
		file deleteIfAbsent: [  ].
		file writeStreamDo: [ :stream |
			currentStream := stream.
			type accept: self ] ].
	aFamixJavaPackage childEntities do: [ :child | child accept: self ]
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaParameter: aFamixJavaParameter [

	aFamixJavaParameter declaredType isParametricEntity
		ifTrue: [
		self visitParameterizableType: aFamixJavaParameter declaredType ]
		ifFalse: [ self << aFamixJavaParameter declaredType name ].
	self
		space;
		<< aFamixJavaParameter name
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaParametricClass: aFamixJavaParametricClass [
	"Printing class package and imports if the class is not an inner class"

	(aFamixJavaParametricClass typeContainer isKindOf: FamixJavaPackage)
		ifTrue: [
			self << 'package '.
			aFamixJavaParametricClass typeContainer fullNamePrintOn:
				currentStream.
			self
				<< ';';
				eol;
				eol.
			self printImports: aFamixJavaParametricClass.
			self eol ].
	"Printing class annotations"
	aFamixJavaParametricClass annotationInstances do: [
		:annotationInstance |
		annotationInstance accept: self clone.
		self eol ].
	"Printing Class declaration"
	self <<| 'public class '.
	self << aFamixJavaParametricClass name. 
	self << '<'.
	aFamixJavaParametricClass genericParameters
		do: [ :genericParam | self << genericParam name ]
		separatedBy: [ self << ', ' ].
	self << '>'.
	"printing inheritance and implementation"
	self printExtends: aFamixJavaParametricClass.
	self printImplements: aFamixJavaParametricClass.
	self << ' {'.
	self eol.
	"Printing Attributs"
	self indentPlus.
	self printContentOfClass: aFamixJavaParametricClass.
	self indentMinus.
	"Closing Class"
	self eol.
	self <<| '}'
]

{ #category : 'visiting' }
FAMIX2JavaVisitor >> visitFamixJavaParametricMethod: aFamixJavaParametricMethod [

	self visitFamixJavaMethod: aFamixJavaParametricMethod
]

{ #category : 'generated' }
FAMIX2JavaVisitor >> visitParameterizableType: aParameterizableType [
	self << aParameterizableType name.
	self << '<'.
	aParameterizableType concreteParameters
		do: [ :concreteParameter | 
			concreteParameter isParameterType
				ifTrue: [ self visitParameterizableType: concreteParameter ]
				ifFalse: [ self << concreteParameter name ] ]
		separatedBy: [ self << ',' ].
	self << '>'
]
