/* MIT License

Copyright 2020 @Shunshun94

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */
var io = io || {};
io.github = io.github || {};
io.github.shunshun94 = io.github.shunshun94 || {};
io.github.shunshun94.trpg = io.github.shunshun94.trpg || {};
io.github.shunshun94.trpg.ccfolia = io.github.shunshun94.trpg.ccfolia || {};

io.github.shunshun94.trpg.ccfolia.getCharacterSeed = ()=>{
	return { kind: "character" };
};

io.github.shunshun94.trpg.ccfolia.generateCharacterJsonFromYtSheet2RuinBreakersPC = async (json, opt_sheetUrl = '') => {
	const result = io.github.shunshun94.trpg.ccfolia.getCharacterSeed();
	const defaultPalette = await io.github.shunshun94.trpg.ytsheet.getChatPalette(opt_sheetUrl);
	const character = {
			name: json.characterName || json.aka,
			playerName: json.playerName,
			memo: `${json.characterNameRuby ? '('+json.characterNameRuby+')\n' :''}PL: ${json.playerName || 'PL情報無し'}\n${json.igr || ''} / ${json.element || ''} / ${json.home || ''}\n\n${json.imageURL ? '立ち絵：' + (json.imageCopyright || '権利情報なし') : ''}`,
			initiative: Number(json.initiativeTotal || 0),
			externalUrl: opt_sheetUrl,
			status: [
				{
					label: 'FP',
					value: json.maxHpTotal,
					max: json.maxHpTotal
				}, {
					label: 'RBP',
					value: 0,
					max: 0
				}
			],
			params: defaultPalette.parameters || [],
			faces: [],
			x: 0, y: 0, z: 0,
			angle: 0, width: 4, height: 4,
			active: true, secret: false,
			invisible: false, hideStatus: false,
			color: '',
			roomId: null,
			commands: defaultPalette.palette || '',
			speaking: true
	};
	result.data = character;
	return JSON.stringify(result);
};
