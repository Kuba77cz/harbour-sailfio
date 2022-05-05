function getDatabase() { return LocalStorage.openDatabaseSync("Tokens", "1.0", "StorageDatabase", 10000000); }

var regex = /[0-9]{4}-[0-9]{2}-[0-9]{2}/i;

function getList() {
    var db = getDatabase();
    var r="";
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT rowid, token, name, active FROM tokens ORDER BY active DESC, rowid');
            for(var i = 0; i < rs.rows.length; i++) {
                r = { "id": rs.rows.item(i).rowid, "token": rs.rows.item(i).token, "name": rs.rows.item(i).name, "active": rs.rows.item(i).active }
                myJSModel.append(r)
            }
        })
    } catch (err) {
        console.log(err)
    }
    return r
}

function getListNonActiveTokens() {
    var db = getDatabase();
    var r="";
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT rowid, token, name FROM tokens WHERE active = 0 ORDER BY rowid');
            for(var i = 0; i < rs.rows.length; i++) {
                r = { "id": rs.rows.item(i).rowid, "token": rs.rows.item(i).token, "name": rs.rows.item(i).name }
                myJSModel.append(r)
            }
        })
    } catch (err) {
        console.log(err)
    }
    return r
}


function getActiveToken() {
    var db = getDatabase();
    var r=[];
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT token FROM tokens WHERE active = 1');
            for(var i = 0; i < 1; i++) {
                r = rs.rows.item(i).token
            }
        })
    } catch (err) {
        console.log(err)
         r = 0
    }
    return r
}

function getActiveTokenName() {
    var db = getDatabase();
    var r="";
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT name FROM tokens WHERE active = 1');
            for(var i = 0; i < 1; i++) {
                r = rs.rows.item(i).name
            }
        })
    } catch (err) {
        console.log(err)
         r = 0
    }
    return r
}

function getActiveTokenID() {
    var db = getDatabase();
    var r="";
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT rowid FROM tokens WHERE active = 1');
            for(var i = 0; i < 1; i++) {
                r = rs.rows.item(i).rowid
            }
        })
    } catch (err) {
        console.log(err)
         r = 0
    }
    return r
}

function addToken(token, name, active) {
    var db = getDatabase();
    var res = ""
    var rs = "";
    db.transaction(function (tx) {
        try {
            tx.executeSql('CREATE TABLE IF NOT EXISTS tokens(token TEXT PRIMARY KEY, name TEXT, active INTEGER)');
            rs = tx.executeSql('INSERT INTO tokens VALUES(?, ?, ?)', [token, name, active]);
        } catch (err) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS tokens(token TEXT PRIMARY KEY, name TEXT, active INTEGER)');
            rs = tx.executeSql('INSERT INTO tokens VALUES(?, ?, ?)', [token, name, active]);
        }

        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}

function deleteFavorite(id) {
    var db = getDatabase();
    var res = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM tokens WHERE rowid=?', [id]);

        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}



function updateActive(active,name) {
    var db = getDatabase();
    var res = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('UPDATE tokens SET active=? WHERE name=?', [active,name]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}

function existPeriod() {
    var db = getDatabase();
    var rs = "";
    var res = "";
    db.transaction(function(tx) {
        try {
            rs = tx.executeSql('SELECT count(*) as count FROM sqlite_master WHERE type="table" AND name="period"');
            for(var i = 0; i < 1; i++) {
                r = rs.rows.item(i).count
                console.log(r)
            }
        } catch (err) {

        }
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}

function updatePeriod(period, pindex) {
    var db = getDatabase();
    var res = "";
    var rs = "";
    db.transaction(function(tx) {
        try {
            rs = tx.executeSql('UPDATE period SET period=?, pindex=? WHERE rowid=1', [period,pindex]);
        } catch (err) {

        }
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}

function createPeriod() {
    var db = getDatabase();
    var res = "";
    var rs = "";
    db.transaction(function(tx) {
        try {
            tx.executeSql('CREATE TABLE IF NOT EXISTS period(period TEXT, pindex INTEGER)');
            rs = tx.executeSql('INSERT INTO period VALUES(?,?)', ["25056e5", 0]);
        } catch (err) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS period(period TEXT, pindex INTEGER)');
        }
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}

function getPeriod() {
    var db = getDatabase();
    var r=[];
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT period FROM period WHERE rowid=1');
            for(var i = 0; i < 1; i++) {
                r = rs.rows.item(i).period
                console.log(r)
            }
        })
    } catch (err) {
        console.log(err)
        createPeriod()
        r = "25056e5"
    }
    return r
}
function getPeriodIndex() {
    var db = getDatabase();
    var r=[];
    try {
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT pindex FROM period WHERE rowid=1');
            for(var i = 0; i < 1; i++) {
                r = rs.rows.item(i).pindex
                console.log(r)
            }
        })
    } catch (err) {
        console.log(err)
         r = 0
    }
    return r
}

//function updateActive(active,id) {
//    var db = getDatabase();
//    var res = ""
//    db.transaction(function(tx) {
//        var rs = tx.executeSql('UPDATE tokens SET active=? WHERE rowid=?', [active,id]);
//        if (rs.rowsAffected > 0) {
//            res = "OK";
//        } else {
//            res = "Error";
//        }
//    });
//    return res;
//}

function updateAll() {
    var db = getDatabase();
    var res = ""
    db.transaction(function(tx) {
        var rs = tx.executeSql('UPDATE tokens SET active=0 WHERE rowid>0');
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    });
    return res;
}
