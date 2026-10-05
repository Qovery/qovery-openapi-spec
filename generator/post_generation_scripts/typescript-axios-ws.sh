#!/bin/sh
sed -i 's/name: "RequiredError"/override name: "RequiredError"/g' "$(find out/qovery-client-ws-typescript-axios/base.ts -type f)"
# axios >= 1.20 types leak a non-exported unique symbol through request<T, R>, so tsc cannot emit declarations without this cast
sed -i 's/return axios.request<T, R>(axiosRequestArgs);/return axios.request<T, R>(axiosRequestArgs) as Promise<R>;/g' "$(find out/qovery-client-ws-typescript-axios/common.ts -type f)"
sed -i 's/"^3.6.4"/"~4.5.2"/g' "$(find out/qovery-client-ws-typescript-axios/package.json -type f)"
cp -r generator/files/typescript-axios/.github out/qovery-client-ws-typescript-axios/
cd out/qovery-client-ws-typescript-axios || exit
npm install
npm run build
