#!/bin/sh
sed -i 's/name: "RequiredError"/override name: "RequiredError"/g' $(find out/qovery-client-typescript-axios/base.ts -type f)
cp -r generator/files/typescript-axios/.github out/qovery-client-typescript-axios/
cd out/qovery-client-typescript-axios
npm i