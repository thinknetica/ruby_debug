<template>
<div class="form-group row help_request_custom_values_value">
  <label class="col-sm-3 col-form-label string optional">
    <h5 v-html="obj.name"/>
  </label>
  <div class="col-12">
    <div class="row">
      <div class="col-6">
        <div class="form-group row">
          <label for="help_request_city_value" class="col-sm-3 col-form-label">Город</label>
          <div class="col-sm-9">
            <input
              id="help_request_city_value"
              class="form-control string optional"
              placeholder="Город"
              type="text"
              v-model="obj.value.city"
            />
          </div>
        </div>
        <div class="form-group row">
          <label for="help_request_district_value" class="col-sm-3 col-form-label">Район</label>
          <div class="col-sm-9">
            <input
              id="help_request_district_value"
              class="form-control string optional"
              placeholder="Район"
              type="text"
              v-model="obj.value.district"
            />
          </div>
        </div>
        <div class="form-group row">
          <label for="help_request_street_value" class="col-sm-3 col-form-label">Улица</label>
          <div class="col-sm-9">
            <input
              id="help_request_street_value"
              class="form-control string optional"
              placeholder="Улица"
              type="text"
              v-model="obj.value.street"
            />
          </div>
        </div>
        <div class="form-group row">
          <label for="help_request_house_value" class="col-sm-3 col-form-label">Дом</label>
          <div class="col-sm-9">
            <input
              class="form-control string optional"
              placeholder="Дом"
              type="text"
              v-model="obj.value.house"
            />
          </div>
        </div>
        <div class="form-group row">
          <label for="help_request_apartment_value" class="col-sm-3 col-form-label">Квартира</label>
          <div class="col-sm-9">
            <input
              id="help_request_apartment_value"
              class="form-control string optional"
              placeholder="Квартира"
              type="text"
              v-model="obj.value.apartment"
            />
          </div>
        </div>
      </div>
      <div class="col-6" style="margin-bottom: 40px;">
        <leaflet-map 
          :marker="obj.value.coordinates" 
          :is-valid="!!obj.value.coordinates" 
          :address-changed-event-name="addressChangedEventName"
          :error-message="emptyPointErrorMessage" 
        />
      </div>
    </div>
  </div>

  <input
    type="hidden"
    :name="getFieldName(index, 'value')" 
    :id="getFieldId(index)"
    :value="addressValue"
  />
  <hidden-field :obj="obj" :index="index" />
</div>
</template>

<script>
import fieldMixin from '../mixins/field-mixin'
import hiddenField from './hidden-field.vue'
import LeafletMap from '../../components/leaflet-map'

export default {
  components: {
    hiddenField,
    LeafletMap
  },

  mixins: [fieldMixin],

  data() {
    return {
      addressValue: '',
      addressChangedEventName: this.getRandomString(),
    }
  },

  props: {
    obj: Object,
    index: Number,
    emptyPointErrorMessage: String
  },

  created() {
    this.obj.value = this.obj.value && JSON.parse(this.obj.value) || {};
    this.addressValue = JSON.stringify(this.obj.value);

    this.$watch('obj.value.city', this.updateAddressString);
    this.$watch('obj.value.district', this.updateAddressString);
    this.$watch('obj.value.street', this.updateAddressString);
    this.$watch('obj.value.house', this.updateAddressString);
    this.$watch('obj.value.apartment', this.updateAddressString);
  },

  mounted() {
    window.vueEventBus.$on(`${this.addressChangedEventName}_marker_changed`, coordinates => {
      this.obj.value.coordinates = coordinates;
    });
  },

  watch: {
    'obj.value': {
      handler() {
        this.addressValue = JSON.stringify(this.obj.value);
      },
      deep: true
    }
  },

  methods: {
    updateAddressString() {
      const addressString = [
        this.obj.value.city,
        this.obj.value.street,
        this.obj.value.house
      ].join(' ');
      window.vueEventBus.$emit(this.addressChangedEventName, addressString);
    },

    getRandomString() {
      return Math.random().toString(36).substr(2,10);
    }
  }
}
</script>