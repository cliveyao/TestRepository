package org.lf.wx.message.security;

import org.junit.Test;

public class WXCryptUtilsTest {

	@Test
	public void test() throws AESException {
		String encrypt = "to6i1wOj6y0WZ+h7wBGxC8yY0gIbeOX6uDH4+Bo6CWshXjAAaOeKvFzZtRHWd9jjOKTgMBjsGSkbB5/ZTXqnp5Ev6/IcmrO0fXwBgfALAsPMqBlnbiOYud6DNc3otZxSyG4vNeEkrV5J3NFrPsmhAkwyZUGancUHA6qgUUfoZMRDU06zejoc0klQOkFfs/FwmjpIdHz3T7RETQB1o3gXv1OYp0PGeA5uDysYYrdGDb2x6D5JDiMxjHmW+m9/c/eP/9OsyffOOLdKbjw3KUASk8Sftshq55seEk5WN6FM8LJQcYMKY6hwtD8ej8j4TyOYgSnV2OS+QUZZb7sgEctwOh3LSKmkzCkV8ZgbB9xu+quv9jJK3ayP8v+8uAUqNVs7KcDLCDnD0WF+JM7GkoV+PZGrVaOLOrZAfjs48f5XNK2vUmp0XJadQ7r/RjsJekW1JDTeTfRjSjbDhEqLfri0NJnrHnyz9VY5VuW3lyzF4hLhoFLXBjEZq1Lx6LUaZ+JHt6MtdmQSOjmb6qA4eK9t4K0Hs/vM7frCWlfa3sjjKDafjikQLJ+o0qvPAW8e8ndbZz/CPnf8k2eKqKVAPeM2gQ==";
		System.out.println(WXEncryptUtils.decrypt(encrypt));
	}

}
