def versionGlobal
def versionN

node() {
	stage('Test own') {
		//powershell 'ipconfig'
	}
	stage('Check git') {
		git branch: 'ModulSix', credentialsId: '637dcd76-0c3a-4df7-bcef-93e659af507f', url: 'https://github.com/SergeyKvyatkovsky/repoTesting.git'
	}
	stage('Build and publish in artifactory') {
		powershell 'gradle incrementVersion'
		powershell 'gradle build'
		powershell 'gradle publish'
		script{
			versionGlobal = readFile encoding: 'UTF-8', file: 'gradle.properties'
			String[] a = versionGlobal.split(" ")
			versionN = a[2]
		}
	}
	stage('Docker up and test node') {
	    powershell 'docker build --build-arg ver=${versionN} -t moveton/tomcat .'
	    powershell 'docker run -it -p 8888:8080 moveton/tomcat'
	}
}

node() {
	stage('test node') {
		sleep 15
		script {
			def verOnTheNode = new URL("http://192.168.99.100:8888/gradleSample/").getText()
			println verOnTheNode
			String[] c =  verOnTheNode.split("<p>")
			println("" + c [1])
			String[] b = c[1].split("</p>")
			println("" + b [0])
			String verOnTheNodeUrl = b[0];
			String versionProp = versionN
			println versionProp
			if (b[0]==versionProp) {
				println("Good")
			} else {
				println ("Bad")
		    	def pingNodeAndFail = new URL("http://192.168.0.46:8080/gradleSample-${versionN}/").getText()
			}
		}
	}
}

node() {
	stage('Tag version and push in git new property') {
		powershell 'dir'
		powershell 'git config --global user.email "moveton@tut.by"'
		powershell 'git config --global user.name "Sergey_KV"'
		withCredentials([usernamePassword(credentialsId: 'a83282e5-8860-40e8-b711-1c27ad649097', passwordVariable: '${Name}', usernameVariable: '${Password}')]) {
			def vers = readFile encoding: 'UTF-8', file: 'gradle.properties'
			String[] c =  vers.split(" ")
			def ver = c [2]
			powershell('git add .')
			powershell('git commit -m "Task6 inc"')
			powershell("git tag v.1.4.56.'${ver}'")
			powershell("git checkout v.1.4.56.'${ver}'")
			powershell('git push "https://${token}@github.com/SergeyKvyatkovsky/repoTesting.git" --tag')
			powershell('git push "https://${token}@github.com/SergeyKvyatkovsky/repoTesting.git" ModulSix')
	    }
	}
}