// File containing React component that will render PayTypeSelector component
import React from 'react';

// Importing different custom payment components stored in same director by rails convention
import NoPayType from './NoPayType';
import CreditCardPayType from './CreditCardPayType';
import CheckPayType from './CheckPayType';
import PurchaseOrderPayType from './PurchaseOrderPayType';

class PayTypeSelector extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedPayType: null // Based on this, custom payment component will be rendere
    }
  }

  onPayTypeSelected = event => {
    this.setState({
      selectedPayType: event.target.value
    });
  }

  render() {
    let PayTypeCustomComponent = NoPayType;
    switch (this.state.selectedPayType) {
      case "Credit card":
        PayTypeCustomComponent = CreditCardPayType;
        break;
      case "Check":
        PayTypeCustomComponent = CheckPayType;
        break;
      case "Purchase order":
        PayTypeCustomComponent = PurchaseOrderPayType;
        break;
      default:
        PayTypeCustomComponent = NoPayType;
        break;
    }

    return (
      <div className='field'>
        <label htmlFor='order_pay_type'>Pay Type</label>
        <select 
          id="order_pay_item" 
          /* 
            Choosing name as order[pay_type] as it is dependent on model fields defined in rails 
            order[pay_type] will map to order[:pay_type]
          */
          name="order[pay_type]" 
          onChange={this.onPayTypeSelected} 
        >
          <option value="">Select a payment method</option>
          <option value="Check">Check</option>
          <option value="Credit card">Credit card</option>
          <option value="Purchase order">Purchase order</option>
        </select>

        <PayTypeCustomComponent />
      </div>
    );
  }
}
export default PayTypeSelector;