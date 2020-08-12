Class {
	#name : #FAMIXVisitor,
	#superclass : #Object,
	#category : #'Famix-Compatibility-Visitor'
}

{ #category : #generated }
FAMIXVisitor >> visit: anEntity [
	^ anEntity accept: self
]

{ #category : #generated }
FAMIXVisitor >> visitAbstractFile: aAbstractFile [
	<generated>
	^ self visitNamedEntity: aAbstractFile
]

{ #category : #generated }
FAMIXVisitor >> visitAbstractFileAnchor: aAbstractFileAnchor [
	<generated>
	^ self visitSourceAnchor: aAbstractFileAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitAccess: aAccess [
	<generated>
	^ self visitAssociation: aAccess
]

{ #category : #generated }
FAMIXVisitor >> visitAnnotationInstance: aAnnotationInstance [
	<generated>
	^ self visitSourcedEntity: aAnnotationInstance
]

{ #category : #generated }
FAMIXVisitor >> visitAnnotationInstanceAttribute: aAnnotationInstanceAttribute [
	<generated>
	^ self visitSourcedEntity: aAnnotationInstanceAttribute
]

{ #category : #generated }
FAMIXVisitor >> visitAnnotationType: aAnnotationType [
	<generated>
	^ self visitType: aAnnotationType
]

{ #category : #generated }
FAMIXVisitor >> visitAnnotationTypeAttribute: aAnnotationTypeAttribute [
	<generated>
	^ self visitAttribute: aAnnotationTypeAttribute
]

{ #category : #generated }
FAMIXVisitor >> visitAssociation: aAssociation [
	<generated>
	^ self visitSourcedEntity: aAssociation
]

{ #category : #generated }
FAMIXVisitor >> visitAttribute: aAttribute [
	<generated>
	^ self visitStructuralEntity: aAttribute
]

{ #category : #generated }
FAMIXVisitor >> visitBehaviouralEntity: aBehaviouralEntity [
	<generated>
	^ self visitContainerEntity: aBehaviouralEntity
]

{ #category : #generated }
FAMIXVisitor >> visitCFile: aCFile [
	<generated>
	^ self visitFile: aCFile
]

{ #category : #generated }
FAMIXVisitor >> visitCSourceLanguage: aCSourceLanguage [
	<generated>
	^ self visitSourceLanguage: aCSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitCaughtException: aCaughtException [
	<generated>
	^ self visitException: aCaughtException
]

{ #category : #generated }
FAMIXVisitor >> visitClass: aClass [
	<generated>
	^ self visitType: aClass
]

{ #category : #generated }
FAMIXVisitor >> visitComment: aComment [
	<generated>
	^ self visitSourcedEntity: aComment
]

{ #category : #generated }
FAMIXVisitor >> visitCompilationUnit: aCompilationUnit [
	<generated>
	^ self visitCFile: aCompilationUnit
]

{ #category : #generated }
FAMIXVisitor >> visitContainerEntity: aContainerEntity [
	<generated>
	^ self visitNamedEntity: aContainerEntity
]

{ #category : #generated }
FAMIXVisitor >> visitCppSourceLanguage: aCppSourceLanguage [
	<generated>
	^ self visitCSourceLanguage: aCppSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitCustomSourceLanguage: aCustomSourceLanguage [
	<generated>
	^ self visitSourceLanguage: aCustomSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitDeclaredException: aDeclaredException [
	<generated>
	^ self visitException: aDeclaredException
]

{ #category : #generated }
FAMIXVisitor >> visitDereferencedInvocation: aDereferencedInvocation [
	<generated>
	^ self visitInvocation: aDereferencedInvocation
]

{ #category : #generated }
FAMIXVisitor >> visitEntity: aEntity [
	<generated>
	^ self subclassResponsibility
]

{ #category : #generated }
FAMIXVisitor >> visitEnum: aEnum [
	<generated>
	^ self visitType: aEnum
]

{ #category : #generated }
FAMIXVisitor >> visitEnumValue: aEnumValue [
	<generated>
	^ self visitStructuralEntity: aEnumValue
]

{ #category : #generated }
FAMIXVisitor >> visitException: aException [
	<generated>
	^ self visitEntity: aException
]

{ #category : #generated }
FAMIXVisitor >> visitFile: aFile [
	<generated>
	^ self visitAbstractFile: aFile
]

{ #category : #generated }
FAMIXVisitor >> visitFileAnchor: aFileAnchor [
	<generated>
	^ self visitAbstractFileAnchor: aFileAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitFolder: aFolder [
	<generated>
	^ self visitAbstractFile: aFolder
]

{ #category : #generated }
FAMIXVisitor >> visitFunction: aFunction [
	<generated>
	^ self visitBehaviouralEntity: aFunction
]

{ #category : #generated }
FAMIXVisitor >> visitGlobalVariable: aGlobalVariable [
	<generated>
	^ self visitStructuralEntity: aGlobalVariable
]

{ #category : #generated }
FAMIXVisitor >> visitHeader: aHeader [
	<generated>
	^ self visitCFile: aHeader
]

{ #category : #generated }
FAMIXVisitor >> visitImplicitVariable: aImplicitVariable [
	<generated>
	^ self visitStructuralEntity: aImplicitVariable
]

{ #category : #generated }
FAMIXVisitor >> visitInclude: aInclude [
	<generated>
	^ self visitAssociation: aInclude
]

{ #category : #generated }
FAMIXVisitor >> visitIndexedFileAnchor: aIndexedFileAnchor [
	<generated>
	^ self visitAbstractFileAnchor: aIndexedFileAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitInheritance: aInheritance [
	<generated>
	^ self visitAssociation: aInheritance
]

{ #category : #generated }
FAMIXVisitor >> visitInvocation: aInvocation [
	<generated>
	^ self visitAssociation: aInvocation
]

{ #category : #generated }
FAMIXVisitor >> visitJavaSourceLanguage: aJavaSourceLanguage [
	<generated>
	^ self visitSourceLanguage: aJavaSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitLeafEntity: aLeafEntity [
	<generated>
	^ self visitNamedEntity: aLeafEntity
]

{ #category : #generated }
FAMIXVisitor >> visitLocalVariable: aLocalVariable [
	<generated>
	^ self visitStructuralEntity: aLocalVariable
]

{ #category : #generated }
FAMIXVisitor >> visitMethod: aMethod [
	<generated>
	^ self visitBehaviouralEntity: aMethod
]

{ #category : #generated }
FAMIXVisitor >> visitModule: aModule [
	<generated>
	^ self visitScopingEntity: aModule
]

{ #category : #generated }
FAMIXVisitor >> visitMooseQueryMockSpecializedInvocation: aMooseQueryMockSpecializedInvocation [
	<generated>
	^ self visitInvocation: aMooseQueryMockSpecializedInvocation
]

{ #category : #generated }
FAMIXVisitor >> visitMultipleFileAnchor: aMultipleFileAnchor [
	<generated>
	^ self visitSourceAnchor: aMultipleFileAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitNamedEntity: aNamedEntity [
	<generated>
	^ self visitSourcedEntity: aNamedEntity
]

{ #category : #generated }
FAMIXVisitor >> visitNamespace: aNamespace [
	<generated>
	^ self visitScopingEntity: aNamespace
]

{ #category : #generated }
FAMIXVisitor >> visitPackage: aPackage [
	<generated>
	^ self visitScopingEntity: aPackage
]

{ #category : #generated }
FAMIXVisitor >> visitParameter: aParameter [
	<generated>
	^ self visitStructuralEntity: aParameter
]

{ #category : #generated }
FAMIXVisitor >> visitParameterType: aParameterType [
	<generated>
	^ self visitType: aParameterType
]

{ #category : #generated }
FAMIXVisitor >> visitParameterizableClass: aParameterizableClass [
	<generated>
	^ self visitClass: aParameterizableClass
]

{ #category : #generated }
FAMIXVisitor >> visitParameterizedType: aParameterizedType [
	<generated>
	^ self visitType: aParameterizedType
]

{ #category : #generated }
FAMIXVisitor >> visitPharoAnchor: aPharoAnchor [
	<generated>
	^ self visitSourceAnchor: aPharoAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitPreprocessorDefine: aPreprocessorDefine [
	<generated>
	^ self visitPreprocessorStatement: aPreprocessorDefine
]

{ #category : #generated }
FAMIXVisitor >> visitPreprocessorIfdef: aPreprocessorIfdef [
	<generated>
	^ self visitPreprocessorStatement: aPreprocessorIfdef
]

{ #category : #generated }
FAMIXVisitor >> visitPreprocessorStatement: aPreprocessorStatement [
	<generated>
	^ self visitSourcedEntity: aPreprocessorStatement
]

{ #category : #generated }
FAMIXVisitor >> visitPrimitiveType: aPrimitiveType [
	<generated>
	^ self visitType: aPrimitiveType
]

{ #category : #generated }
FAMIXVisitor >> visitReference: aReference [
	<generated>
	^ self visitAssociation: aReference
]

{ #category : #generated }
FAMIXVisitor >> visitScopingEntity: aScopingEntity [
	<generated>
	^ self visitContainerEntity: aScopingEntity
]

{ #category : #generated }
FAMIXVisitor >> visitSmalltalkMonticelloSourceLanguage: aSmalltalkMonticelloSourceLanguage [
	<generated>
	^ self visitSourceLanguage: aSmalltalkMonticelloSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitSmalltalkSourceLanguage: aSmalltalkSourceLanguage [
	<generated>
	^ self visitSourceLanguage: aSmalltalkSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitSourceAnchor: aSourceAnchor [
	<generated>
	^ self visitEntity: aSourceAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitSourceLanguage: aSourceLanguage [
	<generated>
	^ self visitEntity: aSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitSourceTextAnchor: aSourceTextAnchor [
	<generated>
	^ self visitSourceAnchor: aSourceTextAnchor
]

{ #category : #generated }
FAMIXVisitor >> visitSourcedEntity: aSourcedEntity [
	<generated>
	^ self visitEntity: aSourcedEntity
]

{ #category : #generated }
FAMIXVisitor >> visitStructuralEntity: aStructuralEntity [
	<generated>
	^ self visitLeafEntity: aStructuralEntity
]

{ #category : #generated }
FAMIXVisitor >> visitThrownException: aThrownException [
	<generated>
	^ self visitException: aThrownException
]

{ #category : #generated }
FAMIXVisitor >> visitTrait: aTrait [
	<generated>
	^ self visitType: aTrait
]

{ #category : #generated }
FAMIXVisitor >> visitTraitUsage: aTraitUsage [
	<generated>
	^ self visitAssociation: aTraitUsage
]

{ #category : #generated }
FAMIXVisitor >> visitType: aType [
	<generated>
	^ self visitContainerEntity: aType
]

{ #category : #generated }
FAMIXVisitor >> visitTypeAlias: aTypeAlias [
	<generated>
	^ self visitType: aTypeAlias
]

{ #category : #generated }
FAMIXVisitor >> visitUnknownSourceLanguage: aUnknownSourceLanguage [
	<generated>
	^ self visitSourceLanguage: aUnknownSourceLanguage
]

{ #category : #generated }
FAMIXVisitor >> visitUnknownVariable: aUnknownVariable [
	<generated>
	^ self visitStructuralEntity: aUnknownVariable
]
