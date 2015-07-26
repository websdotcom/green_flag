// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require bootstrap
//= require backbone-1.0.0
//= require common/backbone.marionette.min

_.templateSettings = {
  evaluate : /\{\[([\s\S]+?)\]\}/g,
  interpolate : /\{\{([\s\S]+?)\}\}/g
};


// NAMESPACE ------------------------------------------------------------------
var GreenFlag = GreenFlag || {};

// APPLICATION ----------------------------------------------------------------
GreenFlag.FeatureEditor = new Backbone.Marionette.Application();

GreenFlag.FeatureEditor.addRegions({
  whiteList: '#white-list',
  rules: '#rules',
  yourStatus: '#your-status',
  decisions: '#decisions',
});

GreenFlag.FeatureEditor.addInitializer(function(options){
  new GreenFlag.PostImageController(options);
});

// CONTROLLER ----------------------------------------------------------------
GreenFlag.PostImageController = Backbone.Marionette.Controller.extend({
  initialize: function(options) {
    this.feature = options.feature;
    this.setupRules(this.feature, options.allVisitorGroups);
    this.setupWhiteList(this.feature);
    this.setupYourStatus(this.feature);
    this.setupDecisions(this.feature);    
  },

  setupRules: function(feature, allVisitorGroups) {
    var ruleList = new GreenFlag.RuleList([], {
      feature: feature,
    });
    window.ruleList = ruleList;
    var rulesView = new GreenFlag.RulesView({
       collection: ruleList,
       allVisitorGroups: allVisitorGroups,
    });
    GreenFlag.FeatureEditor.rules.show(rulesView);
    ruleList.fetch();
  },

  setupWhiteList: function(feature) {
    var whiteList = new GreenFlag.WhiteList([], {
      feature: feature,
    });
    var whiteListView = new GreenFlag.WhiteListView({
      collection: whiteList,
    });
    GreenFlag.FeatureEditor.whiteList.show(whiteListView);
    whiteList.fetch();
  },

  setupYourStatus: function(feature) {
    var status = new GreenFlag.YourStatus({
      feature: feature,
    });
    var yourStatusView = new GreenFlag.YourStatusView({
      model: status
    });
    GreenFlag.FeatureEditor.yourStatus.show(yourStatusView);
    status.fetch();
  },

  setupDecisions: function(feature) {
    var decisionSummary = new GreenFlag.DecisionSummary({
      feature: feature,
      enabled: 0,
      disabled: 0,
    })
    var decisionsView = new GreenFlag.DecisionsView({
      model: decisionSummary,
    });
    GreenFlag.FeatureEditor.decisions.show(decisionsView);
    decisionSummary.fetch();
  },
});

// MODELS ----------------------------------------------------------------
GreenFlag.WhiteList = Backbone.Collection.extend({
  url: function() {
    return '/green_flag/admin/features/'+this.feature.id+'/white_list_users';
  },

  initialize: function(models, options) {
    this.feature = options.feature;
  },
});

GreenFlag.RuleList = Backbone.Collection.extend({

  url: function() {
    return '/green_flag/admin/features/'+this.feature.id+'/rule_list';
  },

  initialize: function(models, options) {
    this.feature = options.feature;

    this.isDirty = false;
    this.on('change add remove sort', this.setDirty, this);
    this.on('sync', this.setClean, this);
  },

  saveRules: function() {
    Backbone.sync('update', this, {
      success: this.setClean,
      error: this.setInvalid,
      context: this,
    });
  },

  setDirty: function() {
    this._setDirtyState(true);
  },

  setClean: function() {
    if(this.isInvalid) {
      this.isInvalid = false;
      this.trigger('change:isInvalid');
    }
    this._setDirtyState(false);
  },

  setInvalid: function() {
    if(!this.isInvalid) {
      this.isInvalid = true;
      this.trigger('change:isInvalid');
    }
  },

  _setDirtyState: function(newIsDirty) {
    newIsDirty = !!newIsDirty;
    if(newIsDirty !== this.isDirty) {
      this.isDirty = newIsDirty;
      this.trigger('change:isDirty');
    }
  },

  sortBy: function(rule) {
    return rule.get('order_by');
  },

  nextOrderBy: function() {
    if(this.isEmpty()) {
      return 0;
    }
    var maxOrder = this.last().get('order_by');
    maxOrder = parseInt(maxOrder, 10);
    return maxOrder + 1;
  }
});

GreenFlag.YourStatus = Backbone.Model.extend({
  url: function() {
    return '/green_flag/admin/features/'+this.feature.id+'/current_visitor_status';
  },

  initialize: function(attributes, options) {
    this.feature = attributes.feature;
  },
});

GreenFlag.DecisionSummary = Backbone.Model.extend({
  url: function() {
    return '/green_flag/admin/features/'+this.feature.id+'/feature_decision_summary';
  },

  initialize: function(attributes, options) {
    this.feature = attributes.feature;
  },

  isNew: function() { return false; }
});

// VIEWS ----------------------------------------------------------------
GreenFlag.WhiteListUserView = Backbone.Marionette.ItemView.extend({
  template: '#white-list-user-template',
  className: 'list-group-item',
  events: {
    'click .destroy-user': 'destroyUser'
  },

  destroyUser: function() {
    this.model.destroy({wait: true});
  }
});

GreenFlag.WhiteListView = Backbone.Marionette.CompositeView.extend({
  template: "#white-list-template",
  itemView: GreenFlag.WhiteListUserView,
  itemViewContainer: '.white-list-user-list',

  events: {
    'click .add-user': 'addUser',
    'keypress .user-email': 'checkForEnter',
  },

  addUser: function() {
    var email = this.$('.user-email').val();
    this.collection.create({ email: email }, { 
      wait: true,
      success: this.clearForm,
      error: this.errorMessage
    });
  },

  checkForEnter: function(e) {
    if(e.keyCode === 13) {
      this.addUser();
    }
  },

  clearForm: function() {
    this.$('.user-email').val('');
    this.$('.error-message').hide();
    this.$('.user-email').focus();
  },
  errorMessage: function() {
    this.$('.error-message').show();
    this.$('.user-email').focus();
  }
});

GreenFlag.CurrentRuleView = Backbone.Marionette.ItemView.extend({
  template: '#current-rule-template',
  tagName: 'tr',

  events: {
    'change .rule-percent': 'setPercent',
    'keypress .rule-percent': 'setPercent',
    'click .remove-rule': 'removeRule',
  },

  setPercent: function() {
    var pct = this.$('.rule-percent').val();
    this.model.set({percentage: pct});
  },

  removeRule: function() {
    this.model.collection.remove(this.model);
  },
});

GreenFlag.RulesView = Backbone.Marionette.CompositeView.extend({
  template: '#rules-template',
  itemView: GreenFlag.CurrentRuleView,
  itemViewContainer: '.current-rules',

  events: {
    'click .add-rule': 'addRule',
    'click .save-rules': 'saveRules',
    'click .revert-rules': 'revertRules',
  },

  initialize: function(options) {
    this.allVisitorGroups = options.allVisitorGroups || [];
    this.listenTo(this.collection, 'change:isDirty', this.setSaveButtons, this);
    this.listenTo(this.collection, 'change:isInvalid', this.setInvalidMessage, this);
    this.listenTo(this.collection, 'sync', this.render);
  },

  saveRules: function() {
    this.collection.saveRules();
  },

  revertRules: function() {
    this.collection.fetch();
  },

  addRule: function() {
    var groupIndex = this.$('select.group-keys').val();
    var group = this.allVisitorGroups[groupIndex];
    this.collection.add({
      group_key: group.key, 
      group_description: group.description, 
      percentage: 0,
      order_by: this.collection.nextOrderBy(),
    });
  },

  setSaveButtons: function() {
    if(this.collection.isDirty) {
      this.$('.save-buttons').show(300);
    } else {
      this.$('.save-buttons').hide();
    }
  },

  setInvalidMessage: function() {
    if(this.collection.isInvalid) {
      this.$('.invalid-message').show(300);
    } else {
      this.$('.invalid-message').hide();
    }
  },

  onRender: function() {
    var selectEl = this.$('select.group-keys');
    _.each(this.allVisitorGroups, function(group, i) {
      var key = group.key;
      selectEl.append("<option value=\""+i+"\">"+key+"</option>")
    });
    this.setSaveButtons();
    this.setInvalidMessage();
  }
});

GreenFlag.YourStatusView = Backbone.Marionette.ItemView.extend({
  template: '#your-status-template',
  modelEvents: {
    'change': 'render',
  },

  serializeData: function() {
    return _.extend({ labelClass: this.labelClass() }, this.model.toJSON());
  },

  labelClass: function() {
    var status = this.model.get('status');
    var label = 'label-default';
    if(status === 'Enabled') {
      label = 'label-success';
    } else if(status === 'Disabled') {
      label = 'label-warning';
    }

    return label;
  },
});

GreenFlag.DecisionsView = Backbone.Marionette.ItemView.extend({
  template: '#decisions-template',
  modelEvents: {
    'change': 'render',
  },
  events: {
    'click .forget-decisions-enabled': 'forgetDecisionsEnabled',
    'click .forget-decisions-disabled': 'forgetDecisionsDisabled',    
  },

  forgetDecisionsEnabled: function() {
    this.model.save({ forget_enabled: true });
  },

  forgetDecisionsDisabled: function() {
    this.model.save({ forget_disabled: true });
  },

});