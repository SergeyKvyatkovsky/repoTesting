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
}

node('tomcat-node-1') {
	stage('Deploy and test node-1') {
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=myworker&vwa=1  '
		sh 'ip addr'
		sh 'cd ~'
		sh 'pwd'
		sh 'ls'
		script{
			println versionGlobal
			println versionN + "##########"
		}
		sh "wget http://192.168.0.202:8081/repository/maven-releases/org/sergeykvyatk/gradleSample/'${versionN}'/gradleSample-'${versionN}'.war"
		sh "mv gradleSample-${versionN}.war /usr/share/tomcat/webapps/gradleSample.war"
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=myworker&vwa=0  '
		sh 'pwd'
		sleep 15
		script {
			def verOnTheNode = new URL("http://192.168.0.46:8080/gradleSample/").getText()
			println verOnTheNode
			String[] c =  verOnTheNode.split(" ")
			println("" + c [2])
			String[] b = c[2].split("</p>")
			println("" + b [0])
			String verOnTheNodeUrl = b[0];
			String versionProp = versionN
			println versionProp
			if (b[0]==versionProp) {
				println("Good")
			} else {
				println ("Bad")
				httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=myworker&vwa=1  '
				def pingNodeAndFail = new URL("http://192.168.0.46:8080/gradleSample-${versionN}/").getText()
			}
		}
	}
}

node('tomcat-node-2') {
	stage('Deploy node-2') {
		sh 'ip addr'
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=other&vwa=0  '
		sh 'ip addr'
		sh 'cd ~'
		sh 'pwd'
		sh 'ls'
		sh "wget http://192.168.0.202:8081/repository/maven-releases/org/sergeykvyatk/gradleSample/'${versionN}'/gradleSample-'${versionN}'.war"
		sh "mv gradleSample-${versionN}.war /usr/share/tomcat/webapps/gradleSample.war"
		sh 'pwd'
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=other&vwa=1  '
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
			powershell('git push "https://c1c5e05aaf586c604d316c2a3d9c825220ecd3c9@github.com/SergeyKvyatkovsky/repoTesting.git" --tag')
			powershell('git push "https://c1c5e05aaf586c604d316c2a3d9c825220ecd3c9@github.com/SergeyKvyatkovsky/repoTesting.git" ModulSix')
	    }
	}
}