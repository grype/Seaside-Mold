Class {
	#name : #BaselineOfMold,
	#superclass : #BaselineOf,
	#category : #BaselineOfMold
}

{ #category : #baselines }
BaselineOfMold >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec repository: 'github://grype/Seaside-Mold/src'.
			spec
				baseline: 'Seaside3';
				with: [ spec repository: 'github://SeasideSt/Seaside:master/repository' ].
			spec
				package: 'Mold' with: [ spec requires: #('Seaside3') ];
				package: 'Mold-Tests' with: [ spec requires: #('Mold') ].
			spec
				group: 'default' with: #('core' 'tests');
				group: 'core' with: #('Mold');
				group: 'tests' with: #('Mold-Tests') ]
]
