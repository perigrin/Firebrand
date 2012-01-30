/* Author:

*/

App = Ember.Application.create();

App.Contact = Ember.Resource.extend({
    url: '/contacts',
    name: 'contact',
    properties: ['first_name', 'last_name'],

    validate: function() {
        if (this.get('first_name') === undefined || this.get('first_name') === '' ||
        this.get('last_name') === undefined || this.get('last_name') === '') {
            return 'Contacts require a first and a last name.';
        }
    },

    fullName: Ember.computed(function() {
        return this.get('first_name') + ' ' + this.get('last_name');
    }).property('first_name', 'last_name')
});

App.contactsController = Ember.ResourceController.create({
    type: App.Contact
});

App.EditContactView = Ember.View.extend({
    tagName: 'form',
    templateName: 'edit-template',

    init: function() {
        // create a new contact that's a duplicate of the contact in the parentView;
        // changes made to the duplicate won't be applied to the original unless
        // everything goes well in submitForm()
        var editableContact = App.Contact.create(this.get('parentView').get('contact'));
        this.set("contact", editableContact);
        this._super();
    },

    didInsertElement: function() {
        this._super();
        this.$('input:first').focus();
    },

    cancelForm: function() {
        this.get("parentView").hideEdit();
    },

    submit: function(event) {
        var self = this;
        var contact = this.get("contact");

        event.preventDefault();

        contact.save()
        .fail(function(e) {
            App.displayError(e);
        })
        .done(function() {
            var parentView = self.get("parentView");
            parentView.get("contact").duplicateProperties(contact);
            parentView.hideEdit();
        });
    }
});

App.ListContactsView = Ember.View.extend({
    templateName: 'list-template',
    contactsBinding: 'App.contactsController',

    showNew: function() {
        this.set('isNewVisible', true);
    },

    hideNew: function() {
        this.set('isNewVisible', false);
    },

    refreshListing: function() {
        App.contactsController.findAll();
    }
});

App.NewContactView = Ember.View.extend({
    tagName: 'form',
    templateName: 'edit-template',

    init: function() {
        this.set("contact", App.Contact.create());
        this._super();
    },

    didInsertElement: function() {
        this._super();
        this.$('input:first').focus();
    },

    cancelForm: function() {
        this.get("parentView").hideNew();
    },

    submit: function(event) {
        var self = this;
        var contact = this.get("contact");

        event.preventDefault();

        contact.save()
        .fail(function(e) {
            App.displayError(e);
        })
        .done(function() {
            App.contactsController.pushObject(contact);
            self.get("parentView").hideNew();
        });
    }
});

App.ShowContactView = Ember.View.extend({
    templateName: 'show-template',
    classNames: ['show-contact'],
    tagName: 'tr',

    doubleClick: function() {
        this.showEdit();
    },

    showEdit: function() {
        this.set('isEditing', true);
    },

    hideEdit: function() {
        this.set('isEditing', false);
    },

    destroyRecord: function() {
        var contact = this.get("contact");

        contact.destroy()
        .done(function() {
            App.contactsController.removeObject(contact);
        });
    }
});

Handlebars.registerHelper('submitButton', function(text) {
  return new Handlebars.SafeString('<button type="submit">' + text + '</button>');
});