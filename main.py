#!/usr/bin/env python

builds = [
    ('index', 'modal,toolbar,settings')
]


def build():
    for config in builds:
        name = config[0]
        templates = config[1].split(',')
        output = "window.JST = {};\n\n"

        for template in templates:
            if template:
                path = 'templates/%s.html' % template
                content = open(path).read().replace('"', '\\"').replace("\n", "")
                content = """window.JST["%s"] = "%s";\n""" % (template, content)
                output += content

        out = open('js/templates/%s.js' % name, 'w')
        out.write(output)
        out.close()


if __name__ == '__main__':
    build()
