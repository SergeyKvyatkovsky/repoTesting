node(){
	stage('Test own desk') {
		powershell 'ipconfig'
	}
	stage('Checkout git') {
			git branch: 'ModulSix', credentialsId: '637dcd76-0c3a-4df7-bcef-93e659af507f', url: 'https://github.com/SergeyKvyatkovsky/DevOps_Training.git'
	}
	stage('Build') {
		script{
			def op = readFile encoding: 'UTF-8', file: 'gradle.properties'
			println op
		}
		powershell 'gradle incrementVersion build publish'
		script{
			def opt = readFile encoding: 'UTF-8', file: 'gradle.properties'
			println opt
		}
	}
}
node('tomcat-node-1') {
	stage('Test node-1') {
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=myworker&vwa=1  '
		sh 'ip addr'
		sh 'cd ~'
		sh 'pwd'
		sh 'ls'
		sh 'wget http://192.168.0.202:8081/repository/maven-releases/org/sergeykvyatk/gradleSample/1/gradleSample-1.war'
		sh 'cp -u gradleSample-1.war /usr/share/tomcat/webapps'
		sh 'pwd'
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=myworker&vwa=0  '
	}
}
node('tomcat-node-2') {
	stage('Test node-2') {
		sh 'ip addr'
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=other&vwa=1  '
		sh 'ip addr'
		sh 'cd ~'
		sh 'pwd'
		sh 'ls'
		sh 'wget http://192.168.0.202:8081/repository/maven-releases/org/sergeykvyatk/gradleSample/1/gradleSample-1.war'
		sh 'cp -u gradleSample-1.war /usr/share/tomcat/webapps'
		//sh 'rm -rf gradleSample-1.war'
		sh 'pwd'
		httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=other&vwa=0  '
		}
}
node() {
	stage('Test version om the node - 1') {
		powershell 'dir'
		script {
			def verOnTheNode = new URL("http://192.168.0.45:8080/gradleSample-1/").getText()
			def opr = readFile encoding: 'UTF-8', file: 'gradle.properties'
			String[] a = opr.split(" ")
			String[] c =  verOnTheNode.split(" ")
			println("" + c [2])
			String[] b = c[2].split("</p>")
			String ver = b[0];
			if (b[0]==a[2]) {
				httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=myworker&vwa=1  '
				httpRequest ignoreSslErrors: true, responseHandle: 'NONE', url: 'http://192.168.0.240/jkmanager?cmd=update&from=list&w=lb&sw=other&vwa=1  '
			} else {
				println ("Good")
			}
		}
		powershell 'git config --global user.email "moveton@tut.by"'
		powershell 'git config --global user.name "Sergey_KV"'
		withCredentials([usernamePassword(credentialsId: 'a83282e5-8860-40e8-b711-1c27ad649097', passwordVariable: '${Name}', usernameVariable: '${Password}')]) {
			def vers = readFile encoding: 'UTF-8', file: 'gradle.properties'
			String[] c =  vers.split(" ")
			def ver = c [2]
			powershell("git tag -a 'v.1.1.0.${ver}' -m '${ver}'")
			powershell('git push https:/${Name}:${Password}@github.com/SergeyKvyatkovsky/repoTesting.git --tags')
		}
	}
}
