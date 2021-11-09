import { Layout,Button } from 'antd';

import {useConnect} from '../../../hooks/usePortal'

const { Header } = Layout;

function HeaderComp() {
    const {address,tryActivate}=useConnect()
    return (
      <Header style={{width: '100%' }}>
        <div className='flex justify-between text-white'>
          <div>Pos Pool</div>
          <div>
          {address&&<div>{address}</div>}
          {!address&&<Button type='primary' onClick={tryActivate}>Connect Portal</Button>}
          </div>
        </div>
      </Header>
    );
  }
  
  export default HeaderComp;