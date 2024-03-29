#!/bin/sh
sed -i 's/name: "RequiredError"/override name: "RequiredError"/g' "$(find out/qovery-client-ws-typescript-axios/base.ts -type f)"
sed -i 's/"^3.6.4"/"~4.5.2"/g' "$(find out/qovery-client-ws-typescript-axios/package.json -type f)"
cp -r generator/files/typescript-axios/.github out/qovery-client-ws-typescript-axios/
cd out/qovery-client-ws-typescript-axios || exit
npm install
npm run build
