/**
 * Created by git on 14-9-18.
 */

Worlds = Backbone.Collection.extend({
    //World对象的集合
    initialize: function (models, options) {
        this.bind("add", options.view.addOneWorld);
    }
});