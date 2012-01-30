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