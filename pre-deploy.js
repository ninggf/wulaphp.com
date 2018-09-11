const umlFolder = 'source/imgs';
const fs = require('fs');
const path = require('path');
const plantuml = require('node-plantuml');

fs.readdirSync(umlFolder).forEach(file => {
    if (/\.puml$/.test(file)) {
        var uml = path.join(umlFolder, file);
        var dest = uml.replace(/\.puml$/, '.png');
        console.log(['convert', uml, dest]);
        var gen = plantuml.generate(uml, {
            format: 'png',
            charset: 'utf8'
        });
        gen.out.pipe(fs.createWriteStream(dest));
        delete gen;
    }
})