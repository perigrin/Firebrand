App.Contact  = Ember.Resource.extend({
  url:        '/',
  name:       'contact',
  properties: ['first_name', 'last_name'],

  validate: function() {
    if (this.get('first_name') === undefined || this.get('first_name') === '' ||
        this.get('last_name') === undefined  || this.get('last_name') === '') {
      return 'Contacts require a first and a last name.';
    }
  },

  fullName: Ember.computed(function() {
    return this.get('first_name') + ' ' + this.get('last_name');
  }).property('first_name', 'last_name')
});