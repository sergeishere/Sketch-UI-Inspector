function onStart(context) {
    loadAndRun(context, function() {
        SketchUIInspector.shared().configure();
    });
}

function onOpen(context) {
    loadAndRun(context, function() {
        SketchUIInspector.shared().openInspector();
    });
}

function loadAndRun(context, callback) {
    var FRAMEWORK_NAME = 'Sketch_UI_Inspector';
    try {
        callback();
    } catch (e) {
        var path = context.plugin
            .urlForResourceNamed(FRAMEWORK_NAME + '.framework')
            .path()
            .stringByDeletingLastPathComponent();
        if (Mocha.sharedRuntime().loadFrameworkWithName_inDirectory(FRAMEWORK_NAME, path)) {
            callback();
        } else {
            print("Error while loading framework '" + FRAMEWORK_NAME + '`');
        }
    }
}
