var plantuml = require('node-plantuml');

hexo.extend.renderer.register('puml', 'svg', function (data, options) {
    return new Promise(function (resolve, reject) {
        var gen = plantuml.generate(data.text, {
            format: 'svg'
        }, function (err, data) {
            if (err) {
                reject(data);
            } else {
                var svg = data.toString('utf8').split('<!--')
                if (svg && svg.length > 0) {
                    resolve(svg[0]);
                } else {
                    reject(data);
                }
            }
        });
    });
});