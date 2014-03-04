module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		sass: {
			dist: {
				files: {
					'style/style.css' : 'sass/style.scss'
				}
			}
		},
		watch: {
			css: {
				files: '**/*.scss',
				tasks: ['sass'],
				options: {
		      livereload: true,
		    },
			}
		}
	});
	grunt.loadNpmTasks('grunt-contrib-sass');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.registerTask('default',['watch']);
}